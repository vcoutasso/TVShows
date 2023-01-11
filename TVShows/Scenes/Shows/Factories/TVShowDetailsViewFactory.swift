import Foundation

@MainActor
enum TVShowDetailsViewFactory {
    static func make(viewModel: TVShowDetailsViewModelProtocol) -> TVShowDetailsView {
        TVShowDetailsView(viewModel: viewModel)
    }
}
