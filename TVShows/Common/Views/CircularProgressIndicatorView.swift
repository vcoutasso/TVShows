import UIKit

final class CircularProgressIndicatorView: UIView {
    // MARK: Lifecycle

    init(fillPercentage: Int) {
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

    let fillPercentage: Int

    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.removeFromSuperlayer()
        progressLayer.removeFromSuperlayer()
        createCircularPath()
    }

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

        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)

        progressLabel.font = .systemFont(ofSize: 0.85 * radius, weight: .bold)
    }

    private func colorForFillPercentage() -> UIColor {
        fillPercentage < 50 ? UIColor.systemRed : fillPercentage < 80 ? UIColor.systemYellow : UIColor.systemGreen
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
        layer.strokeEnd = CGFloat(fillPercentage) / 100
        return layer
    }()

    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .center
        label.textAlignment = .center
        label.text = String(fillPercentage)
        label.textColor = colorForFillPercentage()

        return label
    }()

    private let startAngle = CGFloat(-Double.pi / 2)
    private let endAngle = CGFloat(3 * Double.pi / 2)
}
