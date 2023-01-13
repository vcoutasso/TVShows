import UIKit

@MainActor
enum TVShowsListViewControllerFactory {
    static func `default`() -> TVShowsListViewController {
        make(showsListView: TVShowsListViewFactory.default(), searchController: TVShowsListSearchController())
    }

    static func make(
        showsListView: UIView & TVShowsListViewProtocol,
        searchController: UISearchController & TVShowsListSearchControllerProtocol,
        coordinator: (any FlowCoordinator<ShowsFlow>)? = AppCoordinator.shared.tabCoordinator?.flowCoordinatorFor(ShowsFlow.self)
    ) -> TVShowsListViewController {
        TVShowsListViewController(showsListView: showsListView, searchController: searchController, coordinator: coordinator)
    }
}
