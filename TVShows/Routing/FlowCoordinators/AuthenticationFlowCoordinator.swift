import UIKit

// MARK: - AuthenticationFlow

enum AuthenticationFlow: FlowRoute {
    case register
    case confirm(String)
    case authenticate
}

// MARK: - AuthenticationFlowCoordinator

final class AuthenticationFlowCoordinator: Coordinator {
    typealias Flow = AuthenticationFlow

    // MARK: Internal

    private(set) var rootViewController: UIViewController = UIViewController()
    private(set) var tabBarItem: ((Int) -> UITabBarItem)?
    weak var parentCoordinator: (any MainCoordinator)?

    func start() -> UIViewController {
        let mainController = RegisterPasscodeViewControllerFactory.default()
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
            case .register:
                rootNavigationController?.popToRootViewController(animated: true)
            case .confirm(let passcode):
                let destinationViewController = ConfirmPasscodeViewControllerFactory.make(passcode: passcode)
                rootNavigationController?.pushViewController(destinationViewController, animated: true)
            case .authenticate:
                let destinationViewController = AuthenticationViewControllerFactory.default()
                rootNavigationController?.setViewControllers([destinationViewController], animated: true)
        }
    }
}
