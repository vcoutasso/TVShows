import UIKit

@MainActor
enum TVShowsListViewFactory {
    static func `default`() -> TVShowsListView {
        make(
            viewModel: TVShowsListViewModel(apiService: TVMazeService.default),
            collectionView: UICollectionView(frame: .zero, collectionViewLayout: .init()),
            collectionAdapter: TVShowListViewCollectionViewAdapter()
        )
    }

    static func make(
        viewModel: TVShowListViewCollectionViewAdapterDelegate & TVShowsListViewModelProtocol,
        collectionView: UICollectionView,
        collectionAdapter: TVShowListViewCollectionViewAdapter
    ) -> TVShowsListView {
        TVShowsListView(viewModel: viewModel, collectionView: collectionView, collectionAdapter: collectionAdapter)
    }
}
