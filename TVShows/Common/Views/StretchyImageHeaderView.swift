import UIKit

// MARK: - StretchyImageHeaderView

final class StretchyImageHeaderView: UICollectionReusableView, ReusableView {
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

    func configure(with image: UIImage) {
        imageView.image = image
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeightConstraint.constant = scrollView.contentInset.top
        let verticalOffset = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = verticalOffset <= 0
        imageViewBottomConstraint.constant = verticalOffset >= 0 ? 0 : -verticalOffset / 2
        imageViewHeightConstraint.constant = max(verticalOffset + scrollView.contentInset.top, scrollView.contentInset.top)
    }

    // MARK: Private

    private func setUpView() {
        addSubview(containerView)
        containerView.addSubview(imageView)

        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])

        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalTo: heightAnchor)
        imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)

        NSLayoutConstraint.activate([
            containerViewHeightConstraint,
            imageViewBottomConstraint,
            imageViewHeightConstraint,
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
        ])
    }

    private var containerViewHeightConstraint = NSLayoutConstraint()
    private var imageViewHeightConstraint = NSLayoutConstraint()
    private var imageViewBottomConstraint = NSLayoutConstraint()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
