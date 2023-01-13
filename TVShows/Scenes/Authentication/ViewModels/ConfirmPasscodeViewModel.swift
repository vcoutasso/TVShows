import Foundation

// MARK: - ConfirmPasscodeViewModelProtocol

@MainActor
protocol ConfirmPasscodeViewModelProtocol: AnyObject {
    var codeToConfirm: String { get }

    func savePasscode(_ code: String)
}

// MARK: - ConfirmPasscodeViewModel

final class ConfirmPasscodeViewModel: ConfirmPasscodeViewModelProtocol {
    // MARK: Lifecycle

    init(codeToConfirm: String, passcodeStorage: UserPasscodeStoring) {
        self.codeToConfirm = codeToConfirm
        self.passcodeStorage = passcodeStorage
    }

    // MARK: Internal

    private(set) var codeToConfirm: String

    func savePasscode(_ code: String) {
        passcodeStorage.setPasscode(code)
    }

    // MARK: Private

    private let passcodeStorage: UserPasscodeStoring
}
