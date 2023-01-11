import Foundation
import UIKit

@MainActor
protocol TVShowsListViewModelProtocol: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    init(mazeAPIService: TVMazeServiceProtocol)

    var cellViewModels: [TVShowsListCollectionViewCellViewModelProtocol] { get }
    var delegate: TVShowsListViewModelDelegate? { get set }

    func fetchInitialPage() async
    func fetchNextPage() async
}

@MainActor
protocol TVShowsListViewModelDelegate: AnyObject {
    func didFetchNextPage(with indexPathsToAdd: [IndexPath])
}

final class TVShowsListViewModel: NSObject, TVShowsListViewModelProtocol {
    // MARK: Lifecycle

    init(mazeAPIService: TVMazeServiceProtocol = TVMazeService(jsonDecoder: JSONDecoder(), networkService: NetworkSession.default)) {
        self.mazeAPIService = mazeAPIService
        self.cellViewModels = []
    }

    // MARK: Internal

    private(set) var cellViewModels: [TVShowsListCollectionViewCellViewModelProtocol]

    weak var delegate: TVShowsListViewModelDelegate?

    func fetchInitialPage() async {
        let request = TVMazeRequest(endpoint: .shows, pathComponents: nil, queryItems: nil)
        switch await self.mazeAPIService.execute(request, expecting: [TVShow].self) {
            case .success(let shows):
                let viewModels = shows.map { TVShowsListCollectionViewCellViewModel(show: $0) }
                self.cellViewModels.append(contentsOf: viewModels)
            case .failure(let error):
                print("Failed to fetch shows with error \(error)")
        }
    }

    func fetchNextPage() async {
        guard canLoadMorePages, !isLoadingNextPage else { return }

        isLoadingNextPage = true

        let request = TVMazeRequest(endpoint: .shows, pathComponents: nil, queryItems: [.init(name: "page", value: "\(nextPage)")])

        switch await self.mazeAPIService.execute(request, expecting: [TVShow].self) {
            case .success(let shows):
                nextPage += 1
                let startingIndex = cellViewModels.count
                let indexPathsToAdd = Array(startingIndex..<(startingIndex+shows.count)).map { IndexPath(row: $0, section: 0) }

                let viewModels = shows.map { TVShowsListCollectionViewCellViewModel(show: $0) }
                self.cellViewModels.append(contentsOf: viewModels)

                self.delegate?.didFetchNextPage(with: indexPathsToAdd)
            case .failure(let error):
                if let error = error as? TVMazeService.TVMazeServiceError {
                    if error == .exceededAPIRateLimit {
                        // Try again after two seconds
                        Task {
                            try await Task.sleep(nanoseconds: 2_000_000_000)
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

    // MARK: Private

    private let mazeAPIService: TVMazeServiceProtocol

    private var isLoadingNextPage: Bool = false
    private var canLoadMorePages: Bool = true
    private var nextPage: Int = 1
}

// MARK: - UICollectionViewDelegate + UICollectionViewDataSource + UICollectionViewDelegateFlowLayout

extension TVShowsListViewModel {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(TVShowsListCollectionViewCell.self, for: indexPath) else {
            fatalError("Unsupported cell")
        }

        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        isLoadingNextPage ? CGSize(width: collectionView.frame.width, height: LoadingCollectionViewFooter.LayoutMetrics.spinnerHeight) : .zero
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(LoadingCollectionViewFooter.self, ofKind: kind, for: indexPath) else {
            fatalError("Unsupported supplementary view kind")
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
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - (scrollView.visibleSize.height * 1.15)) {
            Task {
                await fetchNextPage()
            }
        }
    }
}
