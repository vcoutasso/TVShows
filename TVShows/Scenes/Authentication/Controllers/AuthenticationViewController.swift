import UIKit

// MARK: - AuthenticationViewController

final class AuthenticationViewController: UIViewController, Coordinated {
    typealias Flow = AuthenticationFlow

    // MARK: Lifecycle

    init(biometricAuthenticator: BiometricAuthenticationProtocol, coordinator: (any FlowCoordinator<AuthenticationFlow>)?) {
        self.biometricAuthenticator = biometricAuthenticator
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    private(set) var coordinator: (any FlowCoordinator<AuthenticationFlow>)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        if case .success = biometricAuthenticator.canEvaluateBiometrics() {
            Task {
                if case .success = await biometricAuthenticator.evaluateBiometrics() {
                    coordinator?.handleFlow(AppFlow.tab(.shows(.list)))
                }
            }
        }
    }

    // MARK: Private

    private let biometricAuthenticator: BiometricAuthenticationProtocol
}
