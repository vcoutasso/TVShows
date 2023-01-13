import UIKit

// MARK: - TVShowEpisodeDetailsViewProtocol

protocol TVShowEpisodeDetailsViewProtocol: AnyObject {

}

// MARK: - TVShowEpisodeDetailsView

final class TVShowEpisodeDetailsView: UIView {
    // MARK: Lifecycle

    init(viewModel: TVShowEpisodeDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setUpView()
        Task {
            await viewModel.fetchImage()
            if let imageData = viewModel.imageData {
                let image = UIImage(data: imageData)
                backgroundImageView.image = image
                episodeImageView.image = image
            }
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private

    private func setUpView() {
        addSubview(backgroundImageView)
        addSubview(backgroundSpacerView)
        addSubview(backgroundCardView)
        addSubview(episodeImageView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addArrangedSubview(titleStackView)
        contentView.addArrangedSubview(summaryStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: episodeImageView.bottomAnchor, constant: 10),
            scrollView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),

            backgroundSpacerView.topAnchor.constraint(equalTo: bottomAnchor),
            backgroundSpacerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundSpacerView.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundSpacerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            backgroundCardView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            backgroundCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundCardView.bottomAnchor.constraint(equalTo: bottomAnchor),

            episodeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            episodeImageView.centerYAnchor.constraint(equalTo: backgroundCardView.topAnchor),
            episodeImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: frame.height > frame.width ? 0.55 : 0.35),
        ])
    }

    private let viewModel: TVShowEpisodeDetailsViewModelProtocol

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var contentView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.axis = .vertical
        view.spacing = 20
        return view
    }()

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill

        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurEffectView.frame = imageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(blurEffectView)

        return imageView
    }()

    private lazy var backgroundSpacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var backgroundCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        return view
    }()

    private lazy var episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1).bold()
        label.textColor = .label
        label.text = viewModel.episode.name
        return label
    }()

    private lazy var seasonEpisodeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline).bold()
        label.textColor = .secondaryLabel
        label.text = String(format: "S%02d E%02d", viewModel.episode.season, viewModel.episode.number)
        return label
    }()

    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, seasonEpisodeLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()

    private lazy var summaryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Summary"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()

    private lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.text = viewModel.episode.summary?.strippingHTMLTags() ?? "No description available."
        return label
    }()

    private lazy var summaryStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [summaryTitleLabel, summaryLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        stack.axis = .vertical
        stack.spacing = 3
        return stack
    }()
}
