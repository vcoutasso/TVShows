import Foundation

// MARK: - TVShowEpisodeDetailsViewModelProtocol

@MainActor
protocol TVShowEpisodeDetailsViewModelProtocol: AnyObject {
    var imageData: Data? { get }
    var episode: TVShowEpisode { get }

    func fetchImage() async
}

// MARK: - TVShowEpisodeDetailsViewModel

final class TVShowEpisodeDetailsViewModel: TVShowEpisodeDetailsViewModelProtocol {
    // MARK: Lifecycle

    init(episode: TVShowEpisode, imageLoader: ImageLoading) {
        self.episode = episode
        self.imageLoader = imageLoader
    }

    // MARK: Internal

    private(set) var imageData: Data?
    let episode: TVShowEpisode

    func fetchImage() async {
        // No image to be fetched
        guard let imageUrl = episode.image?.medium else { return }
        guard let url = URL(string: imageUrl) else {
            return print("Failed to generate URL for \(imageUrl)")
        }

        switch await imageLoader.fetchImageData(for: url) {
            case .success(let data):
                imageData = data
            case .failure(let error):
                print("Failed to fetch image for \(url.absoluteString) with \(error)")
        }
    }

    // MARK: Private

    private let imageLoader: ImageLoading
}
