import UIKit

@MainActor
enum TVShowDetailsViewFactory {
    static func make(
        viewModel: TVShowDetailsViewModelProtocol & TVShowDetailsViewCollectionViewAdapterDelegate,
        collectionAdapter: TVShowDetailsViewCollectionViewAdapterProtocol
    ) -> TVShowDetailsView {
        TVShowDetailsView(viewModel: viewModel, collectionAdapter: collectionAdapter)
    }
}
