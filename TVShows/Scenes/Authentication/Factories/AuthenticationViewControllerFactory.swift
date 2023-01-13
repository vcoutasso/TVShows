import Foundation

// MARK: - AuthenticationViewControllerFactory

enum AuthenticationViewControllerFactory {
    static func `default`() -> AuthenticationViewController {
        make()
    }

    static func make() -> AuthenticationViewController {
        .init()
    }
}

