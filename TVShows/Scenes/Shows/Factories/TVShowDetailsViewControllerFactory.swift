import UIKit

@MainActor
enum TVShowDetailsViewControllerFactory {
    static func make(
        show: TVShow,
        apiService: TVMazeServiceProtocol = TVMazeService.default,
        imageLoader: ImageLoading = CachedImageLoader.shared
    ) -> TVShowDetailsViewController {
        let detailsViewModel = TVShowDetailsViewModel(show: show, apiService: apiService, imageLoader: imageLoader)
        let collectionViewSections: [TVShowDetailsViewCollectionSections] = [
            .info,
        ]
        let collectionAdapter = TVShowDetailsViewCollectionViewAdapter(show: show, sections: collectionViewSections)
        let detailsView = TVShowDetailsViewFactory.make(viewModel: detailsViewModel, collectionAdapter: collectionAdapter)
        return TVShowDetailsViewController(detailsView: detailsView)
    }
}
