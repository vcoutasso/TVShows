import UIKit

@MainActor
enum TVShowsViewControllerFactory {
    static func `default`() -> TVShowsViewController {
        make(showsListView: TVShowsListViewFactory.default(), searchController: TVShowsSearchController())
    }

    static func make(
        showsListView: UIView & TVShowsListViewProtocol,
        searchController: UISearchController & TVShowsSearchControllerProtocol
    ) -> TVShowsViewController {
        TVShowsViewController(showsListView: showsListView, searchController: searchController)
    }
}
