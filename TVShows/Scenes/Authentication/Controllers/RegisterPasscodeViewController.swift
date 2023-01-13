import UIKit

// MARK: - RegisterPasscodeViewController

final class RegisterPasscodeViewController: UIViewController, Coordinated {
    typealias Flow = AuthenticationFlow

    // MARK: Lifecycle

    init(
        registerPasscodeView: UIView & RegisterPasscodeViewProtocol,
        passcodeStorage: UserPasscodeStoring,
        coordinator: (any FlowCoordinator<AuthenticationFlow>)?
    ) {
        self.registerPasscodeView = registerPasscodeView
        self.passcodeStorage = passcodeStorage
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        registerPasscodeView.delegate = self
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if passcodeStorage.getPasscode() != nil {
            coordinator?.handleFlow(AuthenticationFlow.authenticate)
        }
    }

    // MARK: Private

    private func setUpView() {
        view.backgroundColor = .systemBackground

        registerPasscodeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registerPasscodeView)

        NSLayoutConstraint.activate([
            registerPasscodeView.topAnchor.constraint(equalTo: view.topAnchor),
            registerPasscodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registerPasscodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            registerPasscodeView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
        ])
    }

    private let registerPasscodeView: UIView & RegisterPasscodeViewProtocol
    private let passcodeStorage: UserPasscodeStoring
}

// MARK: - RegisterPasscodeViewDelegate

extension RegisterPasscodeViewController: RegisterPasscodeViewDelegate {
    func didInputPasscode(_ code: String) {
        coordinator?.handleFlow(AuthenticationFlow.confirm(code))
    }
}
