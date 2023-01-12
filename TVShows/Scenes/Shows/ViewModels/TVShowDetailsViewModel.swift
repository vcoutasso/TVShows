import Foundation

// MARK: - TVShowDetailsViewModelProtocol

@MainActor
protocol TVShowDetailsViewModelProtocol: AnyObject {
    init(show: TVShow, apiService: TVMazeServiceProtocol, imageLoader: ImageLoading)

    var delegate: TVShowDetailsViewModelDelegate? { get set }

    var show: TVShow { get }
    var imageData: Data? { get }
    var episodes: [TVShowEpisode]? { get }


    func fetchImage() async
    func fetchEpisodes() async
}

@MainActor
protocol TVShowDetailsViewModelDelegate: AnyObject {
    func didSelectEpisode(_ episode: TVShowEpisode)
}

// MARK: - TVShowDetailsViewModel

final class TVShowDetailsViewModel: TVShowDetailsViewModelProtocol {
    // MARK: Lifecycle

    init(show: TVShow, apiService: TVMazeServiceProtocol, imageLoader: ImageLoading = CachedImageLoader.shared) {
        self.show = show
        self.apiService = apiService
        self.imageLoader = imageLoader
    }

    // MARK: Internal

    weak var delegate: TVShowDetailsViewModelDelegate?

    let show: TVShow
    private(set) var imageData: Data?
    private(set) var episodes: [TVShowEpisode]?

    func fetchImage() async {
        // No image to be fetched
        guard let imageUrl = show.image?.original else { return }
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

    func fetchEpisodes() async {
        let request = TVMazeRequest(endpoint: .shows, pathComponents: [.id(show.id), .episodes], queryItems: nil)
        switch await apiService.execute(request, expecting: [TVShowEpisode].self) {
            case .success(let episodes):
                self.episodes = episodes
            case .failure(let error):
                print("Failed to fetch shows with error \(error)")
        }
    }

    // MARK: Private

    private let imageLoader: ImageLoading
    private let apiService: TVMazeServiceProtocol
}

extension TVShowDetailsViewModel: TVShowDetailsViewCollectionViewAdapterDelegate {
    func episodeName(season: Int, episode: Int) -> String? {
        episodes?.first(where: { $0.season == season && $0.number == episode }).map { $0.name }
    }

    func didSelectCell(at indexPath: IndexPath) {
        if let episode = episodes?.first(where: { $0.season == indexPath.section && $0.number == indexPath.row }) {
            delegate?.didSelectEpisode(episode)
        }
    }
}
