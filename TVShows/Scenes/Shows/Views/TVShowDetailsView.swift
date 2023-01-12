import UIKit

@MainActor
protocol TVShowDetailsViewProtocol {
    var delegate: TVShowsListViewDelegate? { get set }
}

@MainActor
protocol TVShowDetailsViewDelegate {
    func presentEpisodeDetails(_ episode: TVShowEpisode)
}

final class TVShowDetailsView: UIView, TVShowDetailsViewProtocol {
    // MARK: Lifecycle

    init(viewModel: TVShowDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setUpView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    weak var delegate: TVShowsListViewDelegate?

    // MARK: Private

    private func setUpView() {
        backgroundColor = .systemBackground

        populateImageView()

        addSubviews(posterImageView, headerStackView, statusLabel, genresLabel)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            posterImageView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            posterImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),

            headerStackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            headerStackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            headerStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),

            statusLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            statusLabel.topAnchor.constraint(equalTo: headerStackView.bottomAnchor),

            genresLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            genresLabel.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            genresLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 3),

            scoreIndicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
        ])
    }

    private func populateImageView() {
        Task {
            await viewModel.fetchImage()

            if let imageData = viewModel.imageData,
               let image = UIImage(data: imageData) {
                self.posterImageView.image = image
            }
        }
    }

    private let viewModel: TVShowDetailsViewModelProtocol

    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, premieredLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()

    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleStackView, scoreIndicator])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill

        return stack
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.show.name
        label.font = .preferredFont(forTextStyle: .title1).bold()
        label.textColor = .label

        return label
    }()

    private lazy var premieredLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.show.premiered?.localizedDateString()
        label.font = .preferredFont(forTextStyle: .headline).bold()
        label.textColor = .secondaryLabel

        return label
    }()

    private lazy var scoreIndicator: CircularProgressIndicatorView = {
        let averageRating = viewModel.show.rating?.average ?? 0
        let percentage = Int(averageRating * 10.0)
        let score = CircularProgressIndicatorView(fillPercentage: percentage)
        score.translatesAutoresizingMaskIntoConstraints = false
        return score
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.show.status
        label.font = .preferredFont(forTextStyle: .headline).bold()
        label.textColor = .secondaryLabel

        return label
    }()

    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = viewModel.show.genres.joined(separator: " | ")
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .tertiaryLabel

        return label
    }()
}
