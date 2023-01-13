import UIKit

// MARK: - RegisterPasscodeViewProtocol

@MainActor
protocol RegisterPasscodeViewProtocol: AnyObject {
    var delegate: RegisterPasscodeViewDelegate? { get set }
}

// MARK: - RegisterPasscodeViewDelegate

@MainActor
protocol RegisterPasscodeViewDelegate: AnyObject {
    func didInputPasscode(_ code: String)
}

// MARK: - RegisterPasscodeView

final class RegisterPasscodeView: UIView, RegisterPasscodeViewProtocol {
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    var delegate: RegisterPasscodeViewDelegate?

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

    private func didInputPasscode(_ code: String) {
        delegate?.didInputPasscode(code)
    }

    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Register a pin to keep your app safe"
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .label
        return label
    }()

    private lazy var passcodeInputView: PasscodeInputView = {
        let view = PasscodeInputView(expectedCode: nil, maxLength: 4, completionHandler: didInputPasscode)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
}
