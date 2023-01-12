import UIKit

// MARK: - TVShowsListCollectionViewCell

final class TVShowsListCollectionViewCell: UICollectionViewCell, ReusableView {
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemGroupedBackground
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        addSubviews()
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    func configure(with viewModel: TVShowsListCollectionViewCellViewModelProtocol) async {
        nameLabel.text = viewModel.show.name
        if let imageData = await viewModel.getImageData()  {
            posterImageView.image = uiImageFromData(imageData)
        } else {
            Task {
                posterImageView.image = uiImageFromData(await viewModel.fetchImageData())
            }
        }
    }

    override func prepareForReuse() {
        posterImageView.image = nil
        nameLabel.text = nil
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

    private func uiImageFromData(_ data: Data?) -> UIImage? {
        guard let imageData = data else { return nil }

        return UIImage(data: imageData)
    }

    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true

        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if let boldFont = UIFont.preferredFont(forTextStyle: .headline).bold() {
            label.font = boldFont
        }

        return label
    }()
}
