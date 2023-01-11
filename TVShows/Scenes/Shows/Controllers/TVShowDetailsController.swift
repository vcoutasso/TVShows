import UIKit

/// Controller for displaying details about a particular show
final class TVShowDetailsController: UIViewController {
    // MARK: Lifecycle

    init(show: TVShow) {
        self.show = show
        super.init(nibName: nil, bundle: nil)
        setUpView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private

    private func setUpView() {
        view.addSubview(detailsView)

        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
    }

    private lazy var detailsView: TVShowDetailsView = {
        let view = TVShowDetailsView(viewModel: TVShowDetailsViewModel(show: show))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemTeal

        return view
    }()

    private let show: TVShow
}
