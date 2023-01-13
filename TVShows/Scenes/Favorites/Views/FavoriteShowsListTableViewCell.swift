import UIKit

// MARK: - FavoriteShowsListTableViewCell

final class FavoriteShowsListTableViewCell: UITableViewCell, ReusableView {
    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    func configure(with viewModel: FavoriteShowsListTableCellViewModelProtocol) {
        Task {
            if let data = await viewModel.fetchImageData() {
                posterImageView.image = UIImage(data: data)
            }
            nameLabel.text = viewModel.show.name
            genresLabel.text = viewModel.show.genres.joined(separator: " | ")
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        nameLabel.text = nil
        genresLabel.text = nil
    }

    // MARK: Private

    func setUpView() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(genresLabel)

        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            posterImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor),
            posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            nameLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),

            genresLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            genresLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
        ])
    }

    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .headline)
        if let boldFont = label.font.bold() {
            label.font = boldFont
        }
        return label
    }()

    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
}
