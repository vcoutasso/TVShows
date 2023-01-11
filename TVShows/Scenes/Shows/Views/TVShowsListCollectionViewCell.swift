import UIKit

final class TVShowsListCollectionViewCell: UICollectionViewCell, ReusableView {
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemCyan
        contentView.backgroundColor = .secondarySystemBackground
        addSubviews()
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    func configure(with viewModel: TVShowsListCollectionViewCellViewModelProtocol) {
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
    }

    // MARK: Private

    private func addSubviews() {
        contentView.addSubviews(posterImageView)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        ])
    }

    private func uiImageFromData(_ data: Data?) -> UIImage? {
        guard let imageData = data else { return nil }

        return UIImage(data: imageData)
    }

    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()
}
