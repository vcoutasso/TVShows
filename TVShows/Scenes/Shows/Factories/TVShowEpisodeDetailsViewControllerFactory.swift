import Foundation

@MainActor
enum TVShowEpisodeDetailsViewControllerFactory {
    static func make(episode: TVShowEpisode, imageLoader: ImageLoading = CachedImageLoader.shared) -> TVShowEpisodeDetailsViewController {
        let viewModel = TVShowEpisodeDetailsViewModel(episode: episode, imageLoader: imageLoader)
        let episodeView = TVShowEpisodeDetailsView(viewModel: viewModel)
        return TVShowEpisodeDetailsViewController(episodeView: episodeView)
    }
}
