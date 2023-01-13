import LocalAuthentication
import Foundation

// MARK: - BiometricAuthenticationProtocol

protocol BiometricAuthenticationProtocol {
    func canEvaluateBiometrics() -> Result<BiometricAuthentication, BiometricAuthenticationError>
    func evaluateBiometrics() async -> Result<Void, BiometricAuthenticationError>
}

// MARK: - BiometricAuthenticationService

final class BiometricAuthenticationService: BiometricAuthenticationProtocol {
    // MARK: Internal

    func canEvaluateBiometrics() -> Result<BiometricAuthentication, BiometricAuthenticationError> {
        var error: NSError?

        guard context.canEvaluatePolicy(policy, error: &error) else {
            if let error {
                return .failure(.fromNSError(error))
            } else {
                return .failure(.unknown)
            }
        }

        return .success(.fromLABiometryType(context.biometryType))
    }

    func evaluateBiometrics() async -> Result<Void, BiometricAuthenticationError> {
        do {
            try await context.evaluatePolicy(policy, localizedReason: localizedAuthenticationReason)
            return .success(())
        } catch {
            return .failure(.fromNSError(error as NSError))
        }
    }

    // MARK: Private

    private lazy var context: LAContext = {
        let context = LAContext()
        context.localizedFallbackTitle = "Enter pin"
        context.localizedCancelTitle = "Cancel"
        return context
    }()
    private let policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
    private let localizedAuthenticationReason: String = "Authenticate with biometry"
}

// MARK: - BiometricAuthentication

enum BiometricAuthentication {
    case none
    case touchID
    case faceID
    case unknown

    static func fromLABiometryType(_ type: LABiometryType) -> Self {
        switch type {
            case .none: return .none
            case .touchID: return .touchID
            case .faceID: return .faceID
            @unknown default: return .unknown
        }
    }
}

// MARK: - BiometricAuthenticationError

enum BiometricAuthenticationError: LocalizedError {
    case authenticationFailed
    case userCancel
    case userFallback
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockout
    case unknown

    static func fromNSError(_ error: NSError) -> Self {
        switch error {
            case LAError.authenticationFailed: return .authenticationFailed
            case LAError.userCancel: return .userCancel
            case LAError.userFallback: return .userFallback
            case LAError.biometryNotAvailable: return .biometryNotAvailable
            case LAError.biometryNotEnrolled: return .biometryNotEnrolled
            case LAError.biometryLockout: return .biometryLockout
            default: return .unknown
        }
    }
}
