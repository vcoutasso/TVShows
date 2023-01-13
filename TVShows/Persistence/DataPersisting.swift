import Foundation

// MARK: - DataPersisting

protocol DataPersisting: AnyObject {
    func isShowInFavorites(id: Int) -> Bool
    func getFavoriteShows() -> [TVShow]
    func addToFavorites(_ show: TVShow) -> Result<Void, Error>
    func removeFromFavorites(id: Int) -> Result<Void, Error>
}
