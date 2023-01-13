import Foundation

// MARK: - AuthenticationViewControllerFactory

enum AuthenticationViewControllerFactory {
    static func `default`() -> AuthenticationViewController {
        let authentication = BiometricAuthenticationService()
        let passcodeStorage: UserPasscodeStoring = UserDefaultsPasscodeStorage()
        let coordinator = AppCoordinator.shared.authenticationCoordinator

        return make(biometricAuthenticator: authentication, passcodeStorage: passcodeStorage, coordinator: coordinator)
    }

    static func make(
        biometricAuthenticator: BiometricAuthenticationProtocol,
        passcodeStorage: UserPasscodeStoring,
        coordinator: (any FlowCoordinator<AuthenticationFlow>)?
    ) -> AuthenticationViewController {
        .init(biometricAuthenticator: biometricAuthenticator, passcodeStorage: passcodeStorage, coordinator: coordinator)
    }
}

