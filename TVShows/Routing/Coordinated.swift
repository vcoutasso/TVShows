import Foundation

// MARK: - Coordinated

protocol Coordinated {
    var coordinator: (any FlowCoordinator)? { get }
}
