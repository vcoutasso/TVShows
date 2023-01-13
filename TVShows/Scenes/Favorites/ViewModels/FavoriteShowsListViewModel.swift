import Foundation

// MARK: - FavoriteShowsListViewModelProtocol

@MainActor
protocol FavoriteShowsListViewModelProtocol {
    var delegate: FavoriteShowsListViewModelDelegate? { get set }

    var favoriteShowViewModels: [FavoriteShowsListTableCellViewModelProtocol] { get }

    func fetchFavoriteShows() async
}

// MARK: - FavoriteShowsListViewModelDelegate

@MainActor
protocol FavoriteShowsListViewModelDelegate {
    func didSelectCellForShow(_ show: TVShow)
}

// MARK: - FavoriteShowsListViewModel

final class FavoriteShowsListViewModel: FavoriteShowsListViewModelProtocol {
    // MARK: Lifecycle

    init(localDataStore: DataPersisting) {
        self.localDataStore = localDataStore
    }

    // MARK: Internal

    var delegate: FavoriteShowsListViewModelDelegate?
    private(set) var favoriteShowViewModels: [FavoriteShowsListTableCellViewModelProtocol] = []

    func fetchFavoriteShows() async {
        favoriteShowViewModels = localDataStore.getFavoriteShows()
            .sorted {
                $0.name < $1.name
            }
            .map {
                FavoriteShowsListTableCellViewModelFactory.default(show: $0)
            }
    }

    // MARK: Private

    private let localDataStore: DataPersisting
}

// MARK: - FavoriteShowsListViewModel + FavoriteShowsListTableViewAdapterDelegate

extension FavoriteShowsListViewModel: FavoriteShowsListTableViewAdapterDelegate {
    func didSelectCell(at indexPath: IndexPath) {
        delegate?.didSelectCellForShow(favoriteShowViewModels[indexPath.row].show)
    }
}
