import UIKit

/// Controller for displaying details about a particular show
final class TVShowDetailsViewController: UIViewController, Coordinated {
    // MARK: Lifecycle

    init(detailsView: UIView & TVShowDetailsViewProtocol, coordinator: any FlowCoordinator) {
        self.detailsView = detailsView
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        detailsView.delegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    private(set) var coordinator: (any FlowCoordinator)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpNavigationBar()
    }

    // MARK: Private

    private func setUpView() {
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(detailsView)

        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.backgroundColor = .clear

        view.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: view.topAnchor),
            detailsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setUpNavigationBar() {
        let barButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(didTapRightBarButtonItem))
        navigationItem.setRightBarButton(barButtonItem, animated: true)
    }

    @objc
    private func didTapRightBarButtonItem() {
        detailsView.didTapFavoriteButton()
    }

    private let detailsView: UIView & TVShowDetailsViewProtocol
}

extension TVShowDetailsViewController: TVShowDetailsViewDelegate {
    func presentEpisodeDetails(_ episode: TVShowEpisode) {
        coordinator?.handleFlow(ShowsFlow.episodeDetails(episode))
    }

    func updateRightBarButtonImage(with image: UIImage) {
        navigationItem.rightBarButtonItem?.image = image
    }
}

