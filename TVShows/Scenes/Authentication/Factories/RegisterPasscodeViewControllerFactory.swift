import Foundation

// MARK: - RegisterPasscodeViewControllerFactory

enum RegisterPasscodeViewControllerFactory {
    static func `default`() -> RegisterPasscodeViewController {
        let registerPasscodeView = RegisterPasscodeViewFactory.default()
        let passcodeStorage = UserDefaultsPasscodeStorage()
        let coordinator = AppCoordinator.shared.authenticationCoordinator
        return .init(registerPasscodeView: registerPasscodeView, passcodeStorage: passcodeStorage, coordinator: coordinator)
    }
}
