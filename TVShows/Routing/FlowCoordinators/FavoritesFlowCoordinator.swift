import UIKit

// MARK: - FavoritesFlow

enum FavoritesFlow: FlowRoute {
    case list
}

// MARK: - FavoritesFlowCoordinator

final class FavoritesFlowCoordinator: Coordinator {
    typealias Flow = FavoritesFlow

    // MARK: Internal

    private(set) var rootViewController: UIViewController = UIViewController()
    weak var parentCoordinator: (any MainCoordinator)?

    var tabBarItem: ((Int) -> UITabBarItem)? = { tag in
        .init(title: "Favorites", image: UIImage(systemName: "heart"), tag: tag)
    }

    func start() -> UIViewController {
        let mainController = FavoriteTVShowsViewControllerFactory.default()
        let navigationController = UINavigationController(rootViewController: mainController)
        navigationController.navigationBar.prefersLargeTitles = true
        rootViewController = navigationController
        return rootViewController
    }

    func handleFlow<T: FlowRoute>(_ flow: T) {
        guard let flow = flow as? Flow else {
            parentCoordinator?.handleFlow(flow)
            return
        }

        switch flow {
            case .list:
                rootNavigationController?.popToRootViewController(animated: true)
        }
    }
}
