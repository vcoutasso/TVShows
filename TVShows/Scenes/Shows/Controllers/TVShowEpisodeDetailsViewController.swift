import UIKit

final class TVShowEpisodeDetailsViewController: UIViewController, Coordinated {
    // MARK: Lifecycle

    init(episodeView: TVShowEpisodeDetailsView) {
        self.episodeView = episodeView
        super.init(nibName: nil, bundle: nil)
        setUpView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    private(set) var coordinator: (any FlowCoordinator<ShowsFlow>)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    // MARK: Private

    func setUpView() {
        episodeView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(episodeView)

        NSLayoutConstraint.activate([
            episodeView.topAnchor.constraint(equalTo: view.topAnchor),
            episodeView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            episodeView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
    }

    private let episodeView: TVShowEpisodeDetailsView
}
