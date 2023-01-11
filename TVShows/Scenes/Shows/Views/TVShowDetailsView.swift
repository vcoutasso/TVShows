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

        addSubviews(posterImageView)

        Task {
            await viewModel.fetchImage()

            if let imageData = viewModel.imageData,
               let image = UIImage(data: imageData) {
                self.posterImageView.image = image
            }
        }

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            posterImageView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            posterImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2)
        ])
    }

    private let viewModel: TVShowDetailsViewModelProtocol

    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()
}
