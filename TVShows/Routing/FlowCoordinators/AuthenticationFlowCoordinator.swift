import UIKit

// MARK: - AuthenticationFlow

enum AuthenticationFlow: FlowRoute {
    case `default`
    case fallback
}

// MARK: - AuthenticationFlowCoordinator

final class AuthenticationFlowCoordinator: Coordinator {
    typealias Flow = AuthenticationFlow

    // MARK: Internal

    private(set) var rootViewController: UIViewController = UIViewController()
    private(set) var tabBarItem: ((Int) -> UITabBarItem)?
    weak var parentCoordinator: (any MainCoordinator)?

    func start() -> UIViewController {
        let mainController = AuthenticationViewControllerFactory.default()
        let navigationController = UINavigationController(rootViewController: mainController)
        rootViewController = navigationController

        return rootViewController
    }

    @MainActor func handleFlow<T>(_ flow: T) where T : FlowRoute {
        guard let flow = flow as? Flow else {
            parentCoordinator?.handleFlow(flow)
            return
        }

        switch flow {
            case .`default`:
                rootNavigationController?.popToRootViewController(animated: true)
            case .fallback:
                break
        }
    }
}
