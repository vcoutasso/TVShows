import Foundation

@testable import TVShows

final class FakePersistentStorage: DataPersisting {
    var storage: [Int: TVShow] = [:]


    func isShowInFavorites(id: Int) -> Bool {
        storage.contains { $0.key == id }
    }

    func getFavoriteShows() -> [TVShow] {
        storage.values.map { $0 as TVShow }
    }

    func addToFavorites(_ show: TVShow) -> Result<Void, Error> {
        storage[show.id] = show
        return .success(())
    }

    func removeFromFavorites(id: Int) -> Result<Void, Error> {
        if let index = storage.index(forKey: id) {
            storage.remove(at: index)
            return .success(())
        }

        return .failure(StorageError.invalidIdentifier)
    }

    enum StorageError: Error {
        case invalidIdentifier
    }
}
