import UIKit

// MARK: - ShowsFlowCoordinator

final class ShowsFlowCoordinator: Coordinator {
    typealias Flow = ShowsFlow

    // MARK: Internal

    private(set) var rootViewController: UIViewController = UIViewController()
    var parentCoordinator: (any MainCoordinator)?

    var tabBarItem: ((Int) -> UITabBarItem)? = { tag in
        .init(title: "Shows", image: UIImage(systemName: "tv"), tag: tag)
    }

    @MainActor func start() -> UIViewController {
        let mainController = TVShowsListViewControllerFactory.default()
        let navigationController = UINavigationController(rootViewController: mainController)
        navigationController.navigationBar.prefersLargeTitles = true
        rootViewController = navigationController

        return rootViewController
    }

    func handleFlow<T: FlowRoute>(_ flow: T) {
        guard let associatedFlow = flow as? Flow else {
            parentCoordinator?.handleFlow(flow)
            return
        }
        switch associatedFlow {
            case .list:
                rootNavigationController?.popToRootViewController(animated: true)
            case .showDetails(let show):
                parentCoordinator?.handleFlow(AppFlow.favorites(.list))
            case .episodeDetails:
                parentCoordinator?.handleFlow(AppFlow.people(.list))
        }
    }
}

