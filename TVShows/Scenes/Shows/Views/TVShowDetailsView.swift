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
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    weak var delegate: TVShowsListViewDelegate?

    // MARK: Private

    private let viewModel: TVShowDetailsViewModelProtocol
}
