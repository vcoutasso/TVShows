import UIKit

@MainActor
enum TVShowsListViewControllerFactory {
    static func `default`() -> TVShowsListViewController {
        make(showsListView: TVShowsListViewFactory.default(), searchController: TVShowsListSearchController())
    }

    static func make(
        showsListView: UIView & TVShowsListViewProtocol,
        searchController: UISearchController & TVShowsListSearchControllerProtocol
    ) -> TVShowsListViewController {
        TVShowsListViewController(showsListView: showsListView, searchController: searchController)
    }
}
