import UIKit

// MARK: - GradientView

final class GradientView: UIView {
    // MARK: Lifecycle

    init(gradientColors: [UIColor]) {
        self.gradientColors = gradientColors
        super.init(frame: .zero)
        setUpView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    private var gradientLayer: CAGradientLayer? {
        layer as? CAGradientLayer
    }

    // MARK: Private

    private func setUpView() {
        backgroundColor = .clear
        gradientLayer?.colors = gradientColors.map { $0.cgColor }
    }

    private let gradientColors: [UIColor]
}
