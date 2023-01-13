import Foundation

// MARK: - ConfirmPasscodeViewFactory

@MainActor
enum ConfirmPasscodeViewFactory {
    static func `default`(
        passcode: String
    ) -> ConfirmPasscodeView {
        let passcodeStorage = UserDefaultsPasscodeStorage()
        let viewModel = ConfirmPasscodeViewModel(codeToConfirm: passcode, passcodeStorage: passcodeStorage)

        return make(viewModel: viewModel)
    }

    static func make(
        viewModel: ConfirmPasscodeViewModelProtocol
    ) -> ConfirmPasscodeView {
        return .init(viewModel: viewModel)
    }
}
