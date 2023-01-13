import UIKit
import Combine

// MARK: - AppFlow

enum AppFlow: FlowRoute {
    case authentication(AuthenticationFlow)
    case tab(TabFlow)
}

// MARK: - AppCoordinator

final class AppCoordinator: MainCoordinator {
    typealias Flow = AppFlow

    // MARK: Lifecycle

    private init() {}

    // MARK: Internal

    static let shared: AppCoordinator = .init()

    private(set) lazy var childrenCoordinators: [any Coordinator] = [
        AuthenticationFlowCoordinator(),
        TabCoordinator(),
    ]

    var parentCoordinator: (any MainCoordinator)?
    private(set) var tabBarItem: ((Int) -> UITabBarItem)?
    private(set) var rootViewController: UIViewController = UIViewController() {
        didSet {
            rootViewControllerSubject.send(rootViewController)
        }
    }

    let rootViewControllerSubject: PassthroughSubject<UIViewController, Never> = .init()

    var authenticationCoordinator: AuthenticationFlowCoordinator? {
        childrenCoordinators.compactMap { $0 as? AuthenticationFlowCoordinator }.first
    }

    var tabCoordinator: TabCoordinator? {
        childrenCoordinators.compactMap { $0 as? TabCoordinator }.first
    }

    @discardableResult func start() -> UIViewController {
        for coordinator in childrenCoordinators {
            coordinator.start()
            coordinator.parentCoordinator = self
        }

        if let authenticationViewController = authenticationCoordinator?.rootViewController {
            rootViewController = authenticationViewController
        }

        return rootViewController
    }

    func handleFlow<T: FlowRoute>(_ flow: T) {
        guard let flow = flow as? Flow else {
            parentCoordinator?.handleFlow(flow)
            return
        }

        switch flow {
            case .authentication(let route):
                routeToAuthentication(route)
            case .tab(let route):
                routeToTab(route)
        }
    }

    func resetToRoot() -> Self {
        childrenCoordinators.first?.resetToRoot()
        handleFlow(AppFlow.authentication(.register))
        return self
    }

    func flowCoordinatorFor<T: FlowRoute>(_ flow: T.Type) -> (any FlowCoordinator<T>)?  {
        return childrenCoordinators
            .compactMap {
                $0 as? any FlowCoordinator<T>
            }
            .first
    }

    // MARK: Private

    @MainActor private func routeToAuthentication(_ route: AuthenticationFlow) {
        guard let authenticationCoordinator else { return }
        tabCoordinator?.resetToRoot()
        rootViewController = authenticationCoordinator.rootViewController
        authenticationCoordinator.handleFlow(route)
    }

    @MainActor private func routeToTab(_ route: TabFlow) {
        guard let tabCoordinator else { return }
        rootViewController = tabCoordinator.rootViewController
        tabCoordinator.handleFlow(route)
    }
}
