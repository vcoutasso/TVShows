import UIKit

// MARK: - TVShowDetailsViewCollectionViewCell

@MainActor
final class TVShowDetailsInfoCollectionViewCell: UICollectionViewCell, ReusableView {
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

    func configure(with show: TVShow) {
        nameLabel.text = show.name
        premieredLabel.text = show.premiered?.localizedDateString() ?? "Premiered date unavailable."
        scoreIndicator.updatePercentage(with: (show.rating?.average ?? 0) / 10)
        statusLabel.text = show.status
        genresLabel.text = show.genres.joined(separator: " | ")
        var scheduleText = ""
        for day in show.schedule.days {
            scheduleText.append("\(day) \(show.schedule.time)\n")
        }
        scheduleStackView.isHidden = scheduleText.isEmpty
        scheduleLabel.text = scheduleText
        summaryLabel.text = show.summary?.strippingHTMLTags() ?? "No description available."
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        scheduleStackView.isHidden = false
        nameLabel.text = nil
        premieredLabel.text = nil
        scoreIndicator.updatePercentage(with: 0)
        statusLabel.text = nil
        genresLabel.text = nil
        scheduleLabel.text = nil
        summaryLabel.text = nil
    }

    // MARK: Private

    private func setUpView() {
        addSubviews(headerStackView, statusLabel, genresLabel)
        addSubviews(scheduleStackView, summaryStackView)

        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            headerStackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            headerStackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),

            scoreIndicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),

            statusLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            statusLabel.topAnchor.constraint(equalTo: headerStackView.bottomAnchor),

            genresLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            genresLabel.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            genresLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 3),

            scheduleStackView.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 10),
            scheduleStackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            scheduleStackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),

            summaryStackView.topAnchor.constraint(equalTo: scheduleStackView.bottomAnchor, constant: 10),
            summaryStackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            summaryStackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
        ])

    }

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
        label.font = .preferredFont(forTextStyle: .title1).bold()
        label.textColor = .label

        return label
    }()

    private lazy var premieredLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline).bold()
        label.textColor = .secondaryLabel

        return label
    }()

    private lazy var scoreIndicator: CircularProgressIndicatorView = {
        let score = CircularProgressIndicatorView()
        score.translatesAutoresizingMaskIntoConstraints = false
        return score
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline).bold()
        label.textColor = .secondaryLabel

        return label
    }()

    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .tertiaryLabel

        return label
    }()

    private lazy var scheduleTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Schedule"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label

        return label
    }()

    private lazy var scheduleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel

        return label
    }()

    private lazy var scheduleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [scheduleTitleLabel, scheduleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        stack.axis = .vertical
        stack.spacing = 3

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
