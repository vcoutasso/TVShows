import Foundation

@MainActor
enum TVShowsListViewFactory {
    static func `default`() -> TVShowsListView {
        make(
            viewModel: TVShowsListViewModel(apiService: TVMazeService.default),
            collectionAdapter: TVShowListViewCollectionViewAdapter()
        )
    }

    static func make(
        viewModel: TVShowListViewCollectionViewAdapterDelegate & TVShowsListViewModelProtocol,
        collectionAdapter: TVShowListViewCollectionViewAdapter
    ) -> TVShowsListView {
        TVShowsListView(viewModel: viewModel, collectionAdapter: collectionAdapter)
    }
}
