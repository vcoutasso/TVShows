import UIKit

final class PasscodePinView: UIView {
    // MARK: Lifecycle

    init(isFilled: Bool) {
        self.isFilled = isFilled
        super.init(frame: .zero)
        setUpView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    static func empty() -> PasscodePinView {
        .init(isFilled: false)
    }

    static func filled() -> PasscodePinView {
        .init(isFilled: true)
    }

    // MARK: Private

    private func setUpView() {
        addSubview(pin)

        NSLayoutConstraint.activate([
            pin.centerXAnchor.constraint(equalTo: centerXAnchor),
            pin.centerYAnchor.constraint(equalTo: centerYAnchor),
            pin.widthAnchor.constraint(equalTo: pin.heightAnchor),
            pin.heightAnchor.constraint(equalToConstant: 20.0),
        ])
    }

    private let isFilled: Bool

    private lazy var pin: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = isFilled ? .systemGreen : .systemGray4
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
        return view
    }()
}
