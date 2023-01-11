import UIKit
import Combine

// MARK: - TVShowsViewController

/// Main TV Shows controller
final class TVShowsViewController: UIViewController {
    // MARK: Lifecycle

    init(showsListView: UIView & TVShowsListViewProtocol, searchController: UISearchController & TVShowsSearchControllerProtocol) {
        self.showsListView = showsListView
        self.searchController = searchController
        super.init(nibName: nil, bundle: nil)

        self.showsListView.translatesAutoresizingMaskIntoConstraints = false
        self.showsListView.delegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        attachSearchBarSubscriber()
    }

    // MARK: Private

    private func setUpView() {
        title = "TV Shows"

        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.delegate = searchController
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = true

        view.addSubview(showsListView)
        view.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            showsListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            showsListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            showsListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            showsListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
    }

    private func attachSearchBarSubscriber() {
        searchBarSubscriber = searchController.searchBarSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] event in
                guard let self else { return }
                
                switch event {
                    case .receivedQuery(let query):
                        self.showsListView.searchShows(with: query)
                    case .cancelledSearch:
                        self.showsListView.clearFilters()
                }
            }
    }

    private let searchController: UISearchController & TVShowsSearchControllerProtocol
    private var showsListView: UIView & TVShowsListViewProtocol

    private var searchBarSubscriber: AnyCancellable?
}

// MARK: - TVShowsListViewDelegate

extension TVShowsViewController: TVShowsListViewDelegate {
    func presentShowDetails(_ show: TVShow) {
        navigationController?.pushViewController(TVShowDetailsControllerFactory.make(show: show), animated: true)
    }
}
