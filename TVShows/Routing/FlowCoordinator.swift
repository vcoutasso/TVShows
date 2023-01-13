import Foundation

// MARK: - FlowCoordinator

protocol FlowCoordinator<Flow>: AnyObject {
    associatedtype Flow: FlowRoute

    var parentCoordinator: (any MainCoordinator)? { get set }

    func handleFlow<T: FlowRoute>(_ flow: T)
}
