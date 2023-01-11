import UIKit

@MainActor
enum TVShowsViewControllerFactory {
    static func `default`() -> TVShowsViewController {
        make(showsListView: TVShowsListViewFactory.default())
    }

    static func make(showsListView: UIView & TVShowsListViewProtocol) -> TVShowsViewController {
        TVShowsViewController(showsListView: showsListView)
    }
}
