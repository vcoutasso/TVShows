import Foundation

// MARK: - UserPasscodeStoring

protocol UserPasscodeStoring {
    func setPasscode(_ code: String)
    func getPasscode() -> String?
}

// MARK: - UserPasscodeStorage

final class UserDefaultsPasscodeStorage: UserPasscodeStoring {
    // MARK: Internal

    func setPasscode(_ code: String) {
        defaults.set(code, forKey: passcodeKey)
    }

    func getPasscode() -> String? {
        defaults.object(forKey: passcodeKey) as? String
    }

    // MARK: Private

    private let passcodeKey: String = "passcode"
    private let defaults = UserDefaults.standard
}
