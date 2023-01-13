import Foundation

// MARK: - ConfirmPasscodeViewControllerFactory

@MainActor
enum ConfirmPasscodeViewControllerFactory {
    static func make(passcode: String) -> ConfirmPasscodeViewController {
        let confirmPasscodeView = ConfirmPasscodeViewFactory.default(passcode: passcode)
        let coordinator = AppCoordinator.shared.authenticationCoordinator
        return .init(confirmPasscodeView: confirmPasscodeView, coordinator: coordinator)
    }
}
