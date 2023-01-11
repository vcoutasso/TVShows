import UIKit

final class LoadingCollectionViewFooter: UICollectionReusableView, ReusableView {
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    func startAnimating() {
        spinner.startAnimating()
    }

    enum LayoutMetrics {
        static let spinnerHeight: CGFloat = 100
    }

    // MARK: Private

    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: LayoutMetrics.spinnerHeight),
            spinner.widthAnchor.constraint(equalTo: spinner.heightAnchor),
        ])
    }

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true

        return spinner
    }()
}
