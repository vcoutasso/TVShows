import Foundation

@MainActor
enum TVShowsListViewFactory {
    static func `default`() -> TVShowsListView {
        make(viewModel: TVShowsListViewModel(apiService: TVMazeService.default))
    }

    static func make(viewModel: TVShowListViewCollectionViewAdapterDelegate & TVShowsListViewModelProtocol) -> TVShowsListView {
        TVShowsListView(viewModel: viewModel)
    }
}
