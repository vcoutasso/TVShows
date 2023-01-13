import Foundation

@MainActor
enum FavoriteShowsListViewFactory {
    static func `default`() -> FavoriteShowsListView {
        let localDataStore = CoreDataStore.shared
        let viewModel = FavoriteShowsListViewModel(localDataStore: localDataStore)
        let adapter = FavoriteShowsListTableViewAdapter()
        return make(viewModel: viewModel, adapter: adapter)
    }

    static func make(
        viewModel: FavoriteShowsListViewModelProtocol & FavoriteShowsListTableViewAdapterDelegate,
        adapter: FavoriteShowsListTableViewAdapterProtocol
    ) -> FavoriteShowsListView {
        FavoriteShowsListView(viewModel: viewModel, adapter: adapter)
    }
}
