import UIKit

@MainActor
enum TVShowDetailsViewControllerFactory {
    static func make(show: TVShow, imageLoader: ImageLoading = CachedImageLoader.shared) -> TVShowDetailsViewController {
        let detailsViewModel = TVShowDetailsViewModel(show: show, imageLoader: imageLoader)
        let collectionViewSections: [TVShowDetailsViewCollectionSections] = [
            .info,
            .seasons,
            .seasons,
            .seasons,
        ]
        let detailsView = TVShowDetailsViewFactory.make(viewModel: detailsViewModel, collectionAdapter: TVShowDetailsViewCollectionViewAdapter(show: show, sections: collectionViewSections))
        return TVShowDetailsViewController(detailsView: detailsView)
    }
}
