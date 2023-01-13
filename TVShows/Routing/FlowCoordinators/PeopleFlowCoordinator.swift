import UIKit

// MARK: - PeopleFlow

enum PeopleFlow: FlowRoute {
    case list
    case showDetails
}

// MARK: - PeopleFlowCoordinator

final class PeopleFlowCoordinator: Coordinator {
    typealias Flow = PeopleFlow

    // MARK: Internal

    private(set) var rootViewController: UIViewController = UIViewController()
    weak var parentCoordinator: (any MainCoordinator)?

    var tabBarItem: ((Int) -> UITabBarItem)? = { tag in
        .init(title: "People", image: UIImage(systemName: "person"), tag: tag)
    }

    func start() -> UIViewController {
        let mainController = TVShowsPeopleViewControllerFactory.default()
        let navigationController = UINavigationController(rootViewController: mainController)
        rootViewController = navigationController
        return rootViewController
    }

    func handleFlow<T: FlowRoute>(_ flow: T) {
        guard let flow = flow as? Flow else {
            parentCoordinator?.handleFlow(flow)
            return
        }

        switch flow {
            case .list, .showDetails:
                rootNavigationController?.pushViewController(TVShowsPeopleViewController(), animated: true)
        }
    }
}
