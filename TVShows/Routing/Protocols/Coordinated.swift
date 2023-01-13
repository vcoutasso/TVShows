import Foundation

// MARK: - Coordinated

protocol Coordinated {
    associatedtype Flow: FlowRoute

    var coordinator: (any FlowCoordinator<Flow>)? { get }
}
