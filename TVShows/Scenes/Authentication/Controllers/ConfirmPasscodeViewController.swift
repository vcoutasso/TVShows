import UIKit

// MARK: - ConfirmPasscodeViewController

final class ConfirmPasscodeViewController: UIViewController, Coordinated {
    typealias Flow = AuthenticationFlow

    // MARK: Lifecycle

    init(
        confirmPasscodeView: UIView & ConfirmPasscodeViewProtocol,
        coordinator: (any FlowCoordinator<AuthenticationFlow>)?
    ) {
        self.confirmPasscodeView = confirmPasscodeView
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        confirmPasscodeView.delegate = self
        setUpView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    var coordinator: (any FlowCoordinator<AuthenticationFlow>)?

    // MARK: Private

    private func setUpView() {
        view.backgroundColor = .systemBackground

        confirmPasscodeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmPasscodeView)

        NSLayoutConstraint.activate([
            confirmPasscodeView.topAnchor.constraint(equalTo: view.topAnchor),
            confirmPasscodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmPasscodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmPasscodeView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
        ])
    }

    private let confirmPasscodeView: UIView & ConfirmPasscodeViewProtocol
}

// MARK: - ConfirmPasscodeViewDelegate

extension ConfirmPasscodeViewController: ConfirmPasscodeViewDelegate {
    func didConfirmPasscode(_ code: String) {
        coordinator?.handleFlow(AuthenticationFlow.authenticate)
    }
}
