import UIKit

final class TVShowsListCollectionViewCell: UICollectionViewCell, ReusableView {
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        addSubviews()
        addConstraints()
        setupLayer()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    func configure(with viewModel: TVShowsListCollectionViewCellViewModelProtocol) {
        nameLabel.text = viewModel.show.name
        if viewModel.imageData != nil {
            posterImageView.image = uiImageFromData(viewModel.imageData)
        } else {
            Task {
                await viewModel.fetchImage()
                posterImageView.image = uiImageFromData(viewModel.imageData)
            }
        }
    }

    override func prepareForReuse() {
        posterImageView.image = nil
        nameLabel.text = nil
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupLayer()
    }

    // MARK: Private

    private func addSubviews() {
        contentView.addSubviews(posterImageView, nameLabel)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            posterImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.88),
            posterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),

            nameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        ])
    }

    private func setupLayer() {
        contentView.layer.cornerRadius = 4
        contentView.layer.shadowColor = UIColor.tertiarySystemBackground.cgColor
        contentView.layer.shadowOffset = .init(width: -4, height: 4)
        contentView.layer.shadowOpacity = 0.75
    }

    private func uiImageFromData(_ data: Data?) -> UIImage? {
        guard let imageData = data else { return nil }

        return UIImage(data: imageData)
    }

    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if let boldFont = UIFont.preferredFont(forTextStyle: .title3).bold() {
            label.font = boldFont
        }

        return label
    }()
}
