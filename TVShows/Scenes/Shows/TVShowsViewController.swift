import UIKit
import Combine

// MARK: - TVShowsViewController

/// Main TV Shows controller
final class TVShowsViewController: UIViewController {
    // MARK: Lifecycle

    init(showsListView: UIView & TVShowsListViewProtocol) {
        self.showsListView = showsListView
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
        attachSearchBarDebouncer()
    }

    // MARK: Private

    private func setUpView() {
        title = "TV Shows"

        navigationItem.searchController = searchController
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

    private func attachSearchBarDebouncer() {
        searchBarSubscriber = searchBarSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.showsListView.searchShows(with: query)
            }
    }

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self

        return searchController
    }()

    private var showsListView: UIView & TVShowsListViewProtocol

    private var searchBarSubscriber: AnyCancellable?
    private let searchBarSubject: PassthroughSubject<String, Never> = .init()
}

// MARK: - UISearchBarDelegate

extension TVShowsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        !searchText.isEmpty ? searchBarSubject.send(searchText) : cancelSearch()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancelSearch()
    }

    private func cancelSearch() {
        searchBarSubscriber?.cancel()
        showsListView.clearFilters()
        attachSearchBarDebouncer()
    }
}

// MARK: - TVShowsListViewDelegate

extension TVShowsViewController: TVShowsListViewDelegate {
    func presentShowDetails(_ show: TVShow) {
        navigationController?.pushViewController(TVShowDetailsControllerFactory.make(show: show), animated: true)
    }
}
