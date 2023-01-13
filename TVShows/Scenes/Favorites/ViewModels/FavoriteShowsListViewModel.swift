import Foundation

// MARK: - FavoriteShowsListViewModelProtocol

@MainActor
protocol FavoriteShowsListViewModelProtocol {
    var favoriteShowViewModels: [FavoriteShowsListTableCellViewModelProtocol] { get }

    func fetchFavoriteShows() async
}

// MARK: - FavoriteShowsListViewModel

final class FavoriteShowsListViewModel: FavoriteShowsListViewModelProtocol {
    // MARK: Lifecycle

    init(localDataStore: DataPersisting) {
        self.localDataStore = localDataStore
    }

    // MARK: Internal

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
}
