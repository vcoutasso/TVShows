import Foundation

@MainActor
enum TVShowDetailsControllerFactory {
    static func make(show: TVShow, imageLoader: ImageLoading = CachedImageLoader.shared) -> TVShowDetailsController {
        let detailsViewModel = TVShowDetailsViewModel(show: show, imageLoader: imageLoader)
        let detailsView = TVShowDetailsViewFactory.make(viewModel: detailsViewModel, collectionAdapter: TVShowDetailsViewCollectionViewAdapter(show: show))
        return TVShowDetailsController(detailsView: detailsView)
    }
}
