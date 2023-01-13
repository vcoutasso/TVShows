import UIKit

@MainActor
enum TVShowDetailsViewControllerFactory {
    static func make(
        show: TVShow,
        coordinator: any Coordinator,
        apiService: TVMazeServiceProtocol = TVMazeService.default,
        imageLoader: ImageLoading = CachedImageLoader.shared,
        persistentStorage: DataPersisting = CoreDataStore.shared
    ) -> TVShowDetailsViewController {
        let detailsViewModel = TVShowDetailsViewModel(
            show: show,
            apiService: apiService,
            imageLoader: imageLoader,
            persistentStorage: persistentStorage
        )
        let collectionViewSections: [TVShowDetailsViewCollectionSections] = [
            .info,
        ]
        let collectionAdapter = TVShowDetailsViewCollectionViewAdapter(show: show, sections: collectionViewSections)
        let detailsView = TVShowDetailsViewFactory.make(viewModel: detailsViewModel, collectionAdapter: collectionAdapter)
        return TVShowDetailsViewController(detailsView: detailsView, coordinator: coordinator)
    }
}
