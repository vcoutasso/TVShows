import Foundation

// MARK: - MainCoordinator

protocol MainCoordinator: Coordinator {
    var childrenCoordinators: [any Coordinator] { get }
}
