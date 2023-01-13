import UIKit

// MARK: - FavoriteTVShowsViewControllerFactory

@MainActor
enum FavoriteTVShowsViewControllerFactory {
    static func `default`() -> FavoriteTVShowsViewController {
        let listView = FavoriteShowsListViewFactory.default()
        return make(listView: listView)
    }

    static func make(listView: UIView & FavoriteShowsListViewProtocol) -> FavoriteTVShowsViewController {
        FavoriteTVShowsViewController(listView: listView)
    }
}

