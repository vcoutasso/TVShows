import UIKit

// MARK: - PasscodeView

final class PasscodeInputView: UIView, UITextInputTraits {
    // MARK: Lifecycle

    init(expectedCode: String?, maxLength: Int, completionHandler: @escaping (String) -> Void) {
        self.expectedCode = expectedCode
        self.maxLength = maxLength
        self.completionHandler = completionHandler
        super.init(frame: .zero)
        setUpView()
        setUpTapGestureRecognizer()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    override var canBecomeFirstResponder: Bool { true }
    var keyboardType: UIKeyboardType = .numberPad

    // MARK: Private

    private func setUpView() {
        backgroundColor = .systemBackground

        addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setUpTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func showKeyboard() {
        self.becomeFirstResponder()
    }

    private func codeDidChange() {
        updateStack(with: currentCode)
        guard currentCode.count == maxLength else { return }
        if currentCode == expectedCode || expectedCode == nil {
            resignFirstResponder()
            completionHandler?(currentCode)
        }
    }

    private func updateStack(with code: String) {
        var pins = Array(0..<maxLength).map{ _ in PasscodePinView.empty() }
        let filledPins = Array(0..<code.count).map{ _ in PasscodePinView.filled() }

        for (index, element) in filledPins.enumerated() {
            pins[index] = element
        }

        contentView.removeAllArrangedSubviews()
        for view in pins { contentView.addArrangedSubview(view) }
    }

    private let expectedCode: String?
    private let completionHandler: ((String) -> Void)?
    private let maxLength: Int

    private var currentCode: String = "" {
        didSet {
            codeDidChange()
        }
    }

    private lazy var contentView: UIStackView = {
        let emptyPins = Array(0..<self.maxLength).map{ _ in PasscodePinView.empty() }
        let stack = UIStackView(arrangedSubviews: emptyPins)
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .systemBackground
        return stack
    }()
}

// MARK: - PasscodeView + UIKeyInput

extension PasscodeInputView: UIKeyInput {
    var hasText: Bool { currentCode.count > 0 }

    func insertText(_ text: String) {
        if currentCode.count >= maxLength {
            currentCode = ""
        }
        currentCode.append(contentsOf: text)
    }

    func deleteBackward() {
        if !currentCode.isEmpty { currentCode.removeLast() }
    }
}
