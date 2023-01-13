import UIKit

// MARK: - AuthenticationViewController

final class AuthenticationViewController: UIViewController, Coordinated {
    typealias Flow = AuthenticationFlow

    // MARK: Lifecycle

    init(biometricAuthenticator: BiometricAuthenticationProtocol, coordinator: (any FlowCoordinator<AuthenticationFlow>)?) {
        self.biometricAuthenticator = biometricAuthenticator
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        setUpView()
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
                switch await biometricAuthenticator.evaluateBiometrics() {
                    case .success:
                        coordinator?.handleFlow(AppFlow.tab(.shows(.list)))
                    case .failure:
                        fallBackToPasscode()
                }
            }
        }
    }

    // MARK: Private

    private func setUpView() {
        passcodeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passcodeView)

        NSLayoutConstraint.activate([
            passcodeView.topAnchor.constraint(equalTo: view.topAnchor),
            passcodeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            passcodeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            passcodeView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
        ])
    }

    private func fallBackToPasscode() {
        passcodeView.becomeFirstResponder()
    }

    private let biometricAuthenticator: BiometricAuthenticationProtocol

    private lazy var passcodeView = PasscodeInputView(expectedCode: "1234") { [weak self] in
        self?.coordinator?.handleFlow(AppFlow.tab(.shows(.list)))
    }
}
