import Foundation
import UIKit

@MainActor
protocol TVShowsListViewModelProtocol: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    init(mazeAPIService: TVMazeServiceProtocol)

    var displayedCellViewModels: [TVShowsListCollectionViewCellViewModelProtocol] { get }
    var delegate: TVShowsListViewModelDelegate? { get set }

    func fetchInitialPage() async
    func fetchNextPage() async
    func searchShows(with query: String) async
    func cancelSearch()
}

@MainActor
protocol TVShowsListViewModelDelegate: AnyObject {
    func didFetchNextPage(with indexPathsToAdd: [IndexPath])
    func didSearchShows()
}

final class TVShowsListViewModel: NSObject, TVShowsListViewModelProtocol {
    // MARK: Lifecycle

    init(mazeAPIService: TVMazeServiceProtocol = TVMazeService(jsonDecoder: JSONDecoder(), networkService: NetworkSession.default)) {
        self.mazeAPIService = mazeAPIService
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
        switch await self.mazeAPIService.execute(request, expecting: [TVShow].self) {
            case .success(let shows):
                updateList(with: shows)
            case .failure(let error):
                print("Failed to fetch shows with error \(error)")
        }
    }

    func fetchNextPage() async {
        guard canLoadMorePages, !isLoadingNextPage, !isSearching else { return }

        isLoadingNextPage = true

        let request = TVMazeRequest(endpoint: .shows, pathComponents: nil, queryItems: [.page(nextPage)])

        switch await self.mazeAPIService.execute(request, expecting: [TVShow].self) {
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
        displayedCellViewModels = cellViewModels.array.compactMap { $0 as? TVShowsListCollectionViewCellViewModelProtocol }.filter { $0.show.name.contains(query) }
        delegate?.didSearchShows()
    }

    func cancelSearch() {
        isSearching = false
        resetDisplayedCells()
    }

    enum Constants {
        static let delayBetweenRetries: UInt64 = 1_000_000_000
    }

    // MARK: Private

    private let mazeAPIService: TVMazeServiceProtocol

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

// MARK: - UICollectionViewDelegate + UICollectionViewDataSource + UICollectionViewDelegateFlowLayout

extension TVShowsListViewModel {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        displayedCellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(TVShowsListCollectionViewCell.self, for: indexPath)
        else {
            preconditionFailure("Unsupported cell/viewModel")
        }

        let viewModel = displayedCellViewModels[indexPath.row] as TVShowsListCollectionViewCellViewModelProtocol
        cell.configure(with: viewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        isLoadingNextPage ? CGSize(width: collectionView.frame.width, height: LoadingCollectionViewFooter.LayoutMetrics.spinnerHeight) : .zero
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(LoadingCollectionViewFooter.self, ofKind: kind, for: indexPath) else {
            preconditionFailure("Unsupported supplementary view kind")
        }
        footer.startAnimating()
        return footer
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Available width is calculated by subtracting horizontal insets and paddings
        let width = (UIScreen.main.bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - (scrollView.visibleSize.height * 1.1)) {
            Task {
                await fetchNextPage()
            }
        }
    }
}
