import UIKit

// MARK: - FavoriteShowsListViewProtocol

@MainActor
protocol FavoriteShowsListViewProtocol: AnyObject {
    var delegate: FavoriteShowsListViewDelegate? { get set }

    func reloadFavoritesList()
}

// MARK: - FavoriteShowsListViewDelegate

@MainActor
protocol FavoriteShowsListViewDelegate: AnyObject {
    func displayShowDetails(_ show: TVShow)
}

// MARK: - FavoriteShowsListView

final class FavoriteShowsListView: UIView, FavoriteShowsListViewProtocol {
    // MARK: Lifecycle

    init(
        viewModel: FavoriteShowsListViewModelProtocol & FavoriteShowsListTableViewAdapterDelegate,
        adapter: FavoriteShowsListTableViewAdapterProtocol
    ) {
        self.viewModel = viewModel
        self.adapter = adapter
        adapter.delegate = viewModel
        super.init(frame: .zero)
        self.viewModel.delegate = self
        setUpView()
        Task {
            await viewModel.fetchFavoriteShows()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    var delegate: FavoriteShowsListViewDelegate?

    func reloadFavoritesList() {
        Task {
            await viewModel.fetchFavoriteShows()
            tableView.reloadData()
        }
    }

    // MARK: Private

    private func setUpView() {
        backgroundColor = .systemBackground

        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
    }
    
    private var viewModel: FavoriteShowsListViewModelProtocol
    private let adapter: FavoriteShowsListTableViewAdapterProtocol

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoriteShowsListTableViewCell.self)
        tableView.delegate = adapter
        tableView.dataSource = adapter
        return tableView
    }()
}

// MARK: FavoriteShowsListView + FavoriteShowsListViewModelDelegate

extension FavoriteShowsListView: FavoriteShowsListViewModelDelegate {
    func didSelectCellForShow(_ show: TVShow) {
        delegate?.displayShowDetails(show)
    }
}
