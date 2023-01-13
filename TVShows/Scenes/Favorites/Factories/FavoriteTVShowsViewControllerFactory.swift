import Foundation

enum FavoriteTVShowsViewControllerFactory {
    static func `default`() -> FavoriteTVShowsViewController {
        make()
    }

    static func make() -> FavoriteTVShowsViewController {
        FavoriteTVShowsViewController()
    }
}

