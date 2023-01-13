import UIKit

// MARK: - AppCoordinator

final class AppCoordinator: MainCoordinator {
    typealias Flow = AppFlow

    // MARK: Lifecycle

    private init() {}

    // MARK: Internal

    static let shared: AppCoordinator = .init()

    let showsFlowCoordinator = ShowsFlowCoordinator()
    let peopleFlowCoordinator = PeopleFlowCoordinator()
    let favoritesFlowCoordinator = FavoritesFlowCoordinator()

    private(set) lazy var childrenCoordinators: [any Coordinator] = [
        showsFlowCoordinator,
        peopleFlowCoordinator,
        favoritesFlowCoordinator,
    ]

    var parentCoordinator: (any MainCoordinator)?
    private(set) var rootViewController: UIViewController = UIViewController()
    private(set) var tabBarItem: ((Int) -> UITabBarItem)? = nil

    func start() -> UIViewController {
        let tabBarController = UITabBarController()
        rootViewController = tabBarController

        var rootTabBarControllers: [UIViewController] = []

        for (idx, coordinator) in childrenCoordinators.enumerated() {
            let rootVC = coordinator.start()
            if let tabBarItem = coordinator.tabBarItem?(idx) {
                rootVC.tabBarItem = tabBarItem
            }
            coordinator.parentCoordinator = self

            rootTabBarControllers.append(rootVC)
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
            case .shows(let showsFlow):
                guard let index = childrenFlowCoordinators.firstIndex(where: { $0 === showsFlowCoordinator }) else {
                    break
                }
                showsFlowCoordinator.handleFlow(showsFlow)
                rootTabBarController?.selectedIndex = index
            case .people(let peopleFlow):
                guard let index = childrenFlowCoordinators.firstIndex(where: { $0 === peopleFlowCoordinator }) else {
                    break
                }
                peopleFlowCoordinator.handleFlow(peopleFlow)
                rootTabBarController?.selectedIndex = index
            case .favorites(let favoritesFlow):
                guard let index = childrenFlowCoordinators.firstIndex(where: { $0 === favoritesFlowCoordinator }) else {
                    break
                }
                favoritesFlowCoordinator.handleFlow(favoritesFlow)
                rootTabBarController?.selectedIndex = index
        }
    }

    func resetToRoot() -> Self {
        childrenCoordinators.first?.resetToRoot()
        handleFlow(AppFlow.shows(.list))
        return self
    }

    // MARK: Private

    private var rootTabBarController: UITabBarController? {
        rootViewController as? UITabBarController
    }

    private var childrenFlowCoordinators: [any FlowCoordinator] {
        (childrenCoordinators as [any FlowCoordinator])
    }
}

