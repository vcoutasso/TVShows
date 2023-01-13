import UIKit

// MARK: - Coordinator

protocol Coordinator: FlowCoordinator {
    var rootViewController: UIViewController { get }
    var tabBarItem: ((Int) -> UITabBarItem)? { get }

    func start() -> UIViewController
    @discardableResult func resetToRoot() -> Self
}

extension Coordinator {
    var rootNavigationController: UINavigationController? {
        get {
            (rootViewController as? UINavigationController)
        }
    }

    func resetToRoot() -> Self {
        rootNavigationController?.popToRootViewController(animated: false)
        return self
    }
}
