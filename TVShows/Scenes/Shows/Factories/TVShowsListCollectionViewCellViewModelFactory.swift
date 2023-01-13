import Foundation

// MARK: - TVShowsListCollectionViewCellViewModelFactory

@MainActor
enum TVShowsListCollectionViewCellViewModelFactory {
    static func `default`(show: TVShow, imageLoader: ImageLoading = CachedImageLoader.shared) ->  TVShowsListCollectionViewCellViewModel {
        make(show: show, imageLoader: imageLoader)
    }

    static func make(show: TVShow, imageLoader: ImageLoading) ->  TVShowsListCollectionViewCellViewModel {
        .init(show: show, imageLoader: imageLoader)
    }
}
