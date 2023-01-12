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
        visualEffectAnimator.fractionComplete = verticalOffset <= 0 ? -verticalOffset / scrollView.visibleSize.height : 0
        containerView.clipsToBounds = verticalOffset <= 0
        imageViewBottomConstraint.constant = verticalOffset >= 0 ? 0 : -verticalOffset / 2
        imageViewHeightConstraint.constant = max(verticalOffset + scrollView.contentInset.top, scrollView.contentInset.top)
    }

    // MARK: Private

    private func setUpView() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(visualEffectView)

        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalTo: heightAnchor)
        imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)

        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            visualEffectView.heightAnchor.constraint(equalTo: imageView.heightAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            visualEffectView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            containerViewHeightConstraint,
            imageViewBottomConstraint,
            imageViewHeightConstraint,
        ])

        visualEffectAnimator.fractionComplete = 0
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
        view.backgroundColor = .clear
        return view
    }()

    private lazy var visualEffectAnimator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator(duration: 0, curve: .linear) {
            self.visualEffectView.effect = nil
        }
        animator.isReversed = true
        return animator
    }()

    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        return effectView
    }()
}
