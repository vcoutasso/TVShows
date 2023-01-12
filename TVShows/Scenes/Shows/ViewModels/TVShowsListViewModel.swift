@preconcurrency import Combine
import UIKit

// MARK: - TVShowsListViewModelProtocol

protocol TVShowsListViewModelProtocol: AnyActor {
    init(apiService: TVMazeServiceProtocol)

    func setDelegate(_ delegate: TVShowsListViewModelDelegate) async
    func getDisplayedCellViewModel(for indexPath: IndexPath) async -> TVShowsListCollectionViewCellViewModelProtocol
    func fetchInitialPage() async
    func fetchNextPage() async
    func searchShows(with query: String) async
    func cancelSearch() async
}

// MARK: - TVShowsListViewModelDelegate

@MainActor
protocol TVShowsListViewModelDelegate: AnyObject, Sendable {
    func didFetchNextPage(with indexPathsToAdd: [IndexPath])
    func didFetchFilteredShows()
    func didSelectCell(for show: TVShow)
}

// MARK: - TVShowsListViewModel

actor TVShowsListViewModel: NSObject, TVShowsListViewModelProtocol {
    // MARK: Lifecycle
    init(apiService: TVMazeServiceProtocol) {
        self.apiService = apiService
        self.cellViewModels = []
        self.displayedCellViewModels = []
    }

    // MARK: Internal

    func setDelegate(_ delegate: TVShowsListViewModelDelegate) {
        self.delegate = delegate
    }

    func getDisplayedCellViewModel(for indexPath: IndexPath) async -> TVShowsListCollectionViewCellViewModelProtocol {
        displayedCellViewModels[indexPath.row]
    }

    func fetchInitialPage() async {
        let request = TVMazeRequest(endpoint: .shows, pathComponents: nil, queryItems: nil)
        switch await apiService.execute(request, expecting: [TVShow].self) {
            case .success(let shows):
                didLoadFirstPage = true
                updateList(with: shows)
            case .failure(let error):
                if let error = error as? TVMazeService.TVMazeServiceError {
                    handleTVMazeError(error) {
                        await self.fetchInitialPage()
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

                await self.delegate?.didFetchNextPage(with: indexPathsToAdd)
            case .failure(let error):
                if let error = error as? TVMazeService.TVMazeServiceError {
                    handleTVMazeError(error) {
                        await self.fetchNextPage()
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
                await delegate?.didFetchFilteredShows()
            case .failure(let error):
                if let error = error as? TVMazeService.TVMazeServiceError {
                    handleTVMazeError(error)
                }

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

    private weak var delegate: TVShowsListViewModelDelegate?

    // Collection with all cached cell view models
    private var cellViewModels: NSMutableOrderedSet
    // View models for cells that are in display
    private var displayedCellViewModels: [TVShowsListCollectionViewCellViewModelProtocol] {
        didSet {
            displayedCellViewModelsSubject.send(displayedCellViewModels)
        }
    }

    private var didLoadFirstPage: Bool = false
    private var isLoadingNextPage: Bool = false {
        didSet {
            shouldDisplayLoadingFooterSubject.send(isLoadingNextPage)
        }
    }
    private var canLoadMorePages: Bool = true
    private var isSearching: Bool = false
    private var isRetrying: Bool = false
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

    private func handleTVMazeError(_ error: TVMazeService.TVMazeServiceError, retryBlock:  (() async -> Void)? = nil) {
        switch error {
            case .exceededAPIRateLimit:
                Task {
                    try? await Task.sleep(nanoseconds: Constants.delayBetweenRetries)
                    if !isRetrying {
                        isRetrying = true
                        await retryBlock?()
                        isRetrying = false
                    }
                }
            case .noMoreData:
                canLoadMorePages = false
            default:
                break
        }
    }

    private let shouldDisplayLoadingFooterSubject: CurrentValueSubject<Bool, Never> = .init(false)
    private let displayedCellViewModelsSubject: CurrentValueSubject<[TVShowsListCollectionViewCellViewModelProtocol], Never> = .init([])
}

// MARK: - TVShowListViewCollectionViewAdapterDelegate

extension TVShowsListViewModel: TVShowListViewCollectionViewAdapterDelegate {
    nonisolated func cellViewModel(for indexPath: IndexPath) -> TVShowsListCollectionViewCellViewModelProtocol {
        displayedCellViewModelsSubject.value[indexPath.row]
    }

    nonisolated func cellsCount() -> Int {
        displayedCellViewModelsSubject.value.count
    }

    nonisolated func shouldDisplayLoadingFooter() -> Bool {
        shouldDisplayLoadingFooterSubject.value
    }

    func didSelectCell(at indexPath: IndexPath) async {
        let models = displayedCellViewModels[indexPath.row]
        await delegate?.didSelectCell(for: models.show)
    }

    func didScrollPastCurrentContent() async {
        await fetchNextPage()
    }
}
