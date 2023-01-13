import UIKit

// MARK: - AuthenticationViewController

final class AuthenticationViewController: UIViewController, Coordinated {
    typealias Flow = AuthenticationFlow

    // MARK: Lifecycle

    init(
        biometricAuthenticator: BiometricAuthenticationProtocol,
        passcodeStorage: UserPasscodeStoring,
        coordinator: (any FlowCoordinator<AuthenticationFlow>)?
    ) {
        self.biometricAuthenticator = biometricAuthenticator
        self.passcodeStorage = passcodeStorage
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
                        didAuthenticate()
                    case .failure:
                        fallBackToPasscode()
                }
            }
        }
    }

    // MARK: Private

    private func setUpView() {
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

    private func didAuthenticate() {
        coordinator?.handleFlow(AppFlow.tab(.shows(.list)))
    }

    private let biometricAuthenticator: BiometricAuthenticationProtocol
    private let passcodeStorage: UserPasscodeStoring

    private lazy var passcodeView: PasscodeInputView = {
        let passcode = self.passcodeStorage.getPasscode()
        let view = PasscodeInputView(expectedCode: passcode, maxLength: passcode?.count ?? .zero) { [weak self] _ in
            self?.didAuthenticate()
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemPink
        return view
    }()
}
