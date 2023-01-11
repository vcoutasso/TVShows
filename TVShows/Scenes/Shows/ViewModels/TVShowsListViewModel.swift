import Foundation
import UIKit

// MARK: - TVShowsListViewModelProtocol

@MainActor
protocol TVShowsListViewModelProtocol: AnyObject {
    init(apiService: TVMazeServiceProtocol)

    var displayedCellViewModels: [TVShowsListCollectionViewCellViewModelProtocol] { get }
    var delegate: TVShowsListViewModelDelegate? { get set }

    func fetchInitialPage() async
    func fetchNextPage() async
    func searchShows(with query: String) async
    func cancelSearch()
}

// MARK: - TVShowsListViewModelDelegate

@MainActor
protocol TVShowsListViewModelDelegate: AnyObject {
    func didFetchNextPage(with indexPathsToAdd: [IndexPath])
    func didFetchFilteredShows()
    func didSelectCell(for show: TVShow)
}

// MARK: - TVShowsListViewModel

final class TVShowsListViewModel: NSObject, TVShowsListViewModelProtocol {
    // MARK: Lifecycle
    init(apiService: TVMazeServiceProtocol) {
        self.apiService = apiService
        self.cellViewModels = []
        self.displayedCellViewModels = []
    }

    // MARK: Internal

    // Collection with all cached cell view models
    private var cellViewModels: NSMutableOrderedSet

    // View models for cells that are in display
    private(set) var displayedCellViewModels: [TVShowsListCollectionViewCellViewModelProtocol]

    weak var delegate: TVShowsListViewModelDelegate?

    func fetchInitialPage() async {
        let request = TVMazeRequest(endpoint: .shows, pathComponents: nil, queryItems: nil)
        switch await apiService.execute(request, expecting: [TVShow].self) {
            case .success(let shows):
                didLoadFirstPage = true
                updateList(with: shows)
            case .failure(let error):
                if case .exceededAPIRateLimit = error as? TVMazeService.TVMazeServiceError {
                    // Try again after some delay
                    Task {
                        try await Task.sleep(nanoseconds: Constants.delayBetweenRetries)
                        await fetchNextPage()
                    }
                }

                print("Failed to fetch shows with error \(error)")
        }
    }

    func fetchNextPage() async {
        guard didLoadFirstPage, canLoadMorePages, !isLoadingNextPage, !isSearching else { return }

        isLoadingNextPage = true

        let request = TVMazeRequest(endpoint: .shows, pathComponents: nil, queryItems: [.page(nextPage)])

        switch await apiService.execute(request, expecting: [TVShow].self) {
            case .success(let shows):
                nextPage += 1
                let startingIndex = cellViewModels.count
                let indexPathsToAdd = Array(startingIndex..<(startingIndex+shows.count)).map { IndexPath(row: $0, section: 0) }

                updateList(with: shows)

                self.delegate?.didFetchNextPage(with: indexPathsToAdd)
            case .failure(let error):
                if let error = error as? TVMazeService.TVMazeServiceError {
                    if error == .exceededAPIRateLimit {
                        // Try again after some delay
                        Task {
                            try await Task.sleep(nanoseconds: Constants.delayBetweenRetries)
                            await fetchNextPage()
                        }
                    } else if error == .noMoreData {
                        canLoadMorePages = false
                    }
                }

                print("Failed to fetch shows with error \(error)")
        }

        isLoadingNextPage = false
    }

    func searchShows(with query: String) async {
        guard !isLoadingNextPage else { return }

        isSearching = true

        let request = TVMazeRequest(endpoint: .search, pathComponents: [.shows], queryItems: [.query(query)])

        switch await apiService.execute(request, expecting: [TVMazeFuzzySearchResults.Shows].self) {
            case .success(let results):
                let shows = results.map { $0.show }
                updateList(with: shows)
                displayedCellViewModels = shows.map { TVShowsListCollectionViewCellViewModel(show: $0) }
                delegate?.didFetchFilteredShows()
            case .failure(let error):
                print("Failed to search shows with error \(error)")
        }
    }

    func cancelSearch() {
        isSearching = false
        resetDisplayedCells()
    }

    enum Constants {
        static let delayBetweenRetries: UInt64 = 1_000_000_000
    }

    // MARK: Private

    private let apiService: TVMazeServiceProtocol

    private var didLoadFirstPage: Bool = false
    private var isLoadingNextPage: Bool = false
    private var canLoadMorePages: Bool = true
    private var isSearching: Bool = false
    private var nextPage: Int = 1

    private func updateList(with shows: [TVShow]) {
        shows
            .map { TVShowsListCollectionViewCellViewModel(show: $0) }
            .forEach {
                cellViewModels.add($0)
            }

        if !isSearching { resetDisplayedCells() }
    }

    private func resetDisplayedCells() {
        displayedCellViewModels = cellViewModels.array.compactMap { $0 as? TVShowsListCollectionViewCellViewModelProtocol }
    }
}

// MARK: -

extension TVShowsListViewModel: TVShowListViewCollectionViewAdapterDelegate {
    var shouldDisplayLoadingFooter: Bool {
        isLoadingNextPage
    }

    func didSelectCell(at indexPath: IndexPath) {
        delegate?.didSelectCell(for: displayedCellViewModels[indexPath.row].show)
    }

    func didScrollPastCurrentContent() {
        Task {
            await fetchNextPage()
        }
    }
}
