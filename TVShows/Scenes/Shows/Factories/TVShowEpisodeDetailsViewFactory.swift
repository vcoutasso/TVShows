import Foundation

@MainActor
enum TVShowEpisodeDetailsViewFactory {
    static func make(viewModel: TVShowEpisodeDetailsViewModelProtocol) -> TVShowEpisodeDetailsView {
        TVShowEpisodeDetailsView(viewModel: viewModel)
    }
}
