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
        addSubview(titleStackView)
        addSubview(summaryStackView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),

            backgroundSpacerView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            backgroundSpacerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundSpacerView.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundSpacerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            backgroundCardView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            backgroundCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundCardView.bottomAnchor.constraint(equalTo: bottomAnchor),

            episodeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            episodeImageView.centerYAnchor.constraint(equalTo: backgroundCardView.topAnchor),
            episodeImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.55),

            titleStackView.topAnchor.constraint(equalTo: episodeImageView.bottomAnchor, constant: 10),
            titleStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            summaryStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 20),
            summaryStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            summaryStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }

    private let viewModel: TVShowEpisodeDetailsViewModelProtocol

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
