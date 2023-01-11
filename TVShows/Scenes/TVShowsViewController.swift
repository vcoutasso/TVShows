import UIKit
import Combine

/// Controller to display and list TV Shows
final class TVShowsViewController: UIViewController {

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        attachSearchBarDebouncer()
    }

    // MARK: Private

    private lazy var showsListView: UIView & TVShowsListViewProtocol = {
        let view = TVShowsListView(viewModel: TVShowsListViewModel())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private func setUpView() {
        title = "TV Shows"

        navigationItem.searchController = searchController

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
        searchBarEventListener = searchBarSubject
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

    private var searchBarEventListener: AnyCancellable?
    private let searchBarSubject: PassthroughSubject<String, Never> = .init()
}

// MARK: - UISearchBarDelegate

extension TVShowsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarSubject.send(searchText)
    }
}
