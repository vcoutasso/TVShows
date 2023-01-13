import Foundation

// MARK: - MainCoordinator

protocol MainCoordinator: Coordinator {
    var childrenCoordinators: [any Coordinator] { get }

    func flowCoordinatorFor<T: FlowRoute>(_ flow: T.Type) -> (any FlowCoordinator<T>)?
}
