import Foundation

@MainActor
enum FavoriteTVShowsViewControllerFactory {
    static func `default`() -> FavoriteTVShowsViewController {
        make()
    }

    static func make() -> FavoriteTVShowsViewController {
        FavoriteTVShowsViewController()
    }
}

