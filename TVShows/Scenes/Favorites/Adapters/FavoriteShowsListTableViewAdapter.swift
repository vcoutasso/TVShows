import UIKit

// MARK: - FavoriteShowsListTableViewAdapter

@MainActor
protocol FavoriteShowsListTableViewAdapterProtocol: UITableViewDelegate, UITableViewDataSource {
    var delegate: FavoriteShowsListTableViewAdapterDelegate? { get set }
}

@MainActor
protocol FavoriteShowsListTableViewAdapterDelegate {
    var favoriteShowViewModels: [FavoriteShowsListTableCellViewModelProtocol] { get }

    func didSelectCell(at indexPath: IndexPath)
}

// MARK: - FavoriteShowsListTableViewAdapter

final class FavoriteShowsListTableViewAdapter: NSObject, FavoriteShowsListTableViewAdapterProtocol {
    // MARK: Internal

    var delegate: FavoriteShowsListTableViewAdapterDelegate?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.favoriteShowViewModels.count ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(FavoriteShowsListTableViewCell.self, for: indexPath),
              let viewModel = delegate?.favoriteShowViewModels[indexPath.row]
        else {
            preconditionFailure("Unsupported table view cell")
        }
        cell.configure(with: viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectCell(at: indexPath)
    }
}
