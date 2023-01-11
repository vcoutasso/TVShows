import UIKit

/// Controller for displaying details about a particular show
final class TVShowDetailsController: UIViewController {
    // MARK: Lifecycle

    init(show: TVShow) {
        self.show = show
        super.init(nibName: nil, bundle: nil)
        setUpView()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: Private

    private func setUpView() {
        view.addSubview(detailsView)

        view.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: view.topAnchor),
            detailsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private lazy var detailsView: TVShowDetailsView = {
        let view = TVShowDetailsView(viewModel: TVShowDetailsViewModel(show: show))
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let show: TVShow
}
