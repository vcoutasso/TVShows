import UIKit

// MARK: - ConfirmPasscodeViewProtocol

@MainActor
protocol ConfirmPasscodeViewProtocol: AnyObject {
    var delegate: ConfirmPasscodeViewDelegate? { get set }
}

// MARK: - ConfirmPasscodeViewDelegate

@MainActor
protocol ConfirmPasscodeViewDelegate: AnyObject {
    func didConfirmPasscode(_ code: String)
}

// MARK: - ConfirmPasscodeView

final class ConfirmPasscodeView: UIView, ConfirmPasscodeViewProtocol {
    // MARK: Lifecycle

    init(viewModel: ConfirmPasscodeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setUpView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal

    var delegate: ConfirmPasscodeViewDelegate?

    // MARK: Private

    private func setUpView() {
        backgroundColor = .systemBackground

        addSubview(instructionLabel)
        addSubview(passcodeInputView)

        NSLayoutConstraint.activate([
            instructionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            instructionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            passcodeInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            passcodeInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            passcodeInputView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25),
            passcodeInputView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor),
        ])

        passcodeInputView.becomeFirstResponder()
    }

    private func didConfirmPasscode(_ code: String) {
        viewModel.savePasscode(code)
        delegate?.didConfirmPasscode(code)
    }

    private let viewModel: ConfirmPasscodeViewModelProtocol

    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please confirm your pin"
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .label
        return label
    }()

    private lazy var passcodeInputView: PasscodeInputView = {
        let view = PasscodeInputView(
            expectedCode: viewModel.codeToConfirm,
            maxLength: viewModel.codeToConfirm.count,
            completionHandler: didConfirmPasscode
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
}
