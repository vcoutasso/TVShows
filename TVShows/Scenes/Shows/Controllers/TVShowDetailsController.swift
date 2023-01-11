import UIKit

/// Controller for displaying details about a particular show
final class TVShowDetailsController: UIViewController {
    // MARK: Lifecycle

    init(show: TVShow) {
        self.show = show
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemMint
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let show: TVShow
}
