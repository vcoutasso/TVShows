import Foundation

// MARK: - AuthenticationViewControllerFactory

enum AuthenticationViewControllerFactory {
    static func `default`() -> AuthenticationViewController {
        let authentication = BiometricAuthenticationService()
        let coordinator = AppCoordinator.shared.authenticationCoordinator

        return make(biometricAuthenticator: authentication, coordinator: coordinator)
    }

    static func make(
        biometricAuthenticator: BiometricAuthenticationProtocol,
        coordinator: (any FlowCoordinator<AuthenticationFlow>)?
    ) -> AuthenticationViewController {
        .init(biometricAuthenticator: biometricAuthenticator, coordinator: coordinator)
    }
}

