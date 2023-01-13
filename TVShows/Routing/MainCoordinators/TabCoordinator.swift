import UIKit

// MARK: - TabFlow

enum TabFlow: FlowRoute {
    case shows(ShowsFlow)
    case people(PeopleFlow)
    case favorites(FavoritesFlow)
}

// MARK: - TabCoordinator

final class TabCoordinator: MainCoordinator {
    typealias Flow = TabFlow

    // MARK: Internal

    private(set) lazy var childrenCoordinators: [any Coordinator] = [
        ShowsFlowCoordinator(),
        PeopleFlowCoordinator(),
        FavoritesFlowCoordinator(),
    ]

    var parentCoordinator: (any MainCoordinator)?
    private(set) var rootViewController: UIViewController = UIViewController()
    private(set) var tabBarItem: ((Int) -> UITabBarItem)?

    func start() -> UIViewController {
        let tabBarController = UITabBarController()
        rootViewController = tabBarController

        var rootTabBarControllers: [UIViewController] = []

        for (idx, coordinator) in childrenCoordinators.enumerated() {
            let rootVC = coordinator.start()
            if let tabBarItem = coordinator.tabBarItem?(idx) {
                rootVC.tabBarItem = tabBarItem
                rootTabBarControllers.append(rootVC)
            }
            coordinator.parentCoordinator = self
        }

        tabBarController.viewControllers = rootTabBarControllers

        return tabBarController
    }

    func handleFlow<T: FlowRoute>(_ flow: T) {
        guard let flow = flow as? Flow else {
            parentCoordinator?.handleFlow(flow)
            return
        }

        switch flow {
            case .shows(let route):
                routeToCoordinator(route)
            case .people(let route):
                routeToCoordinator(route)
            case .favorites(let route):
                routeToCoordinator(route)
        }
    }

    @discardableResult func resetToRoot() -> Self {
        childrenCoordinators.first?.resetToRoot()
        handleFlow(TabFlow.shows(.list))
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

    @MainActor private func routeToCoordinator<T: FlowRoute>(_ route: T) {
        guard let coordinator = flowCoordinatorFor(type(of: route)),
              let index = childrenCoordinators.firstIndex(where: { $0 as any FlowCoordinator === coordinator })
        else { return }
        coordinator.handleFlow(route)
        rootTabBarController?.selectedIndex = index
    }

    private var rootTabBarController: UITabBarController? {
        rootViewController as? UITabBarController
    }
}

