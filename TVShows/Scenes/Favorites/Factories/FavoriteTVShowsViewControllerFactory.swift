import UIKit

// MARK: - FavoriteTVShowsViewControllerFactory

@MainActor
enum FavoriteTVShowsViewControllerFactory {
    static func `default`() -> FavoriteTVShowsViewController {
        let listView = FavoriteShowsListViewFactory.default()
        let coordinator = AppCoordinator.shared.tabCoordinator?.flowCoordinatorFor(FavoritesFlow.self)
        return make(listView: listView, coordinator: coordinator)
    }

    static func make(
        listView: UIView & FavoriteShowsListViewProtocol,
        coordinator: (any FlowCoordinator<FavoritesFlow>)?
    ) -> FavoriteTVShowsViewController {
        FavoriteTVShowsViewController(listView: listView, coordinator: coordinator)
    }
}

