import Foundation
import UIKit

@MainActor
protocol TVShowsListViewModelProtocol: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    init(mazeAPIService: TVMazeServiceProtocol)

    var cellViewModels: [TVShowsListCollectionViewCellViewModelProtocol] { get }

    func fetchInitialPage() async
    func fetchNextPage() async
}

final class TVShowsListViewModel: NSObject, TVShowsListViewModelProtocol {
    // MARK: Lifecycle

    init(mazeAPIService: TVMazeServiceProtocol = TVMazeService(jsonDecoder: JSONDecoder(), networkService: NetworkSession.default)) {
        self.mazeAPIService = mazeAPIService
        self.cellViewModels = []
    }

    // MARK: Internal

    private(set) var cellViewModels: [TVShowsListCollectionViewCellViewModelProtocol]

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

    }

    // MARK: Private

    private let mazeAPIService: TVMazeServiceProtocol
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Available width is calculated by subtracting horizontal insets
        let width = (UIScreen.main.bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}
