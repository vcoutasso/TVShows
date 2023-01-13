import UIKit

/// Circular progress indicator view that fills its outline according to the `fillPercentage` attribute
final class CircularProgressIndicatorView: UIView {
    // MARK: Lifecycle

    /// Initializer
    /// - Parameter fillPercentage: The relative location at which to stop stroking the outline
    init(fillPercentage: CGFloat = 0.0) {
        self.fillPercentage = fillPercentage
        super.init(frame: .zero)
        addSubview(progressLabel)

        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.removeFromSuperlayer()
        progressLayer.removeFromSuperlayer()
        createCircularPath()
    }

    func updatePercentage(with value: CGFloat) {
        fillPercentage = value
        setNeedsLayout()
    }

    private(set) var fillPercentage: CGFloat

    // MARK: Private

    private func createCircularPath() {
        let radius = min(frame.size.width, frame.size.height) / 2.5
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )

        circleLayer.path = circularPath.cgPath
        circleLayer.lineWidth = radius / 3
        circleLayer.strokeColor = colorForFillPercentage().cgColor.copy(alpha: 0.3)

        progressLayer.path = circularPath.cgPath
        progressLayer.lineWidth = radius / 3
        progressLayer.strokeColor = colorForFillPercentage().cgColor

        progressLabel.text = String(Int(fillPercentage * 100.0))
        progressLabel.font = .systemFont(ofSize: 0.85 * radius, weight: .bold)
        progressLabel.textColor = colorForFillPercentage()

        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }

    private func colorForFillPercentage() -> UIColor {
        fillPercentage < 0.5 ? UIColor.systemRed : fillPercentage < 0.8 ? UIColor.systemYellow : UIColor.systemGreen
    }

    private lazy var circleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .butt
        layer.strokeEnd = 1.0
        return layer
    }()

    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.strokeEnd = fillPercentage
        return layer
    }()

    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .center
        label.textAlignment = .center

        return label
    }()

    private let startAngle = CGFloat(-Double.pi / 2)
    private let endAngle = CGFloat(3 * Double.pi / 2)
}
