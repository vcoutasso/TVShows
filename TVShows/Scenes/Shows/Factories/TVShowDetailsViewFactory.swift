import Foundation

@MainActor
enum TVShowDetailsViewFactory {
    static func make(viewModel: TVShowDetailsViewModelProtocol, collectionAdapter: TVShowDetailsViewCollectionViewAdapterProtocol) -> TVShowDetailsView {
        TVShowDetailsView(viewModel: viewModel, collectionAdapter: collectionAdapter)
    }
}
