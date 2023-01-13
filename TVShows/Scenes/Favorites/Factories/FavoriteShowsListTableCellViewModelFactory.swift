import Foundation

// MARK: - FavoriteShowsListTableCellViewModelFactory

@MainActor
enum FavoriteShowsListTableCellViewModelFactory{
    static func `default`(show: TVShow, imageLoader: ImageLoading = CachedImageLoader.shared) -> FavoriteShowsListTableCellViewModel {
        make(show: show, imageLoader: imageLoader)
    }
    
    static func make(show: TVShow, imageLoader: ImageLoading) -> FavoriteShowsListTableCellViewModel {
        .init(show: show, imageLoader: imageLoader)
    }
}

