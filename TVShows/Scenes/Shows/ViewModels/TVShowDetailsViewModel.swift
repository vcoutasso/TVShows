import Foundation

// MARK: - TVShowDetailsViewModelProtocol

@MainActor
protocol TVShowDetailsViewModelProtocol: AnyObject {
    var delegate: TVShowDetailsViewModelDelegate? { get set }

    var show: TVShow { get }
    var imageData: Data? { get }
    var episodes: [TVShowEpisode]? { get }
    var isShowInFavorites: Bool { get }

    func fetchData() async
    func handleFavoriteButtonTapped()
}

@MainActor
protocol TVShowDetailsViewModelDelegate: AnyObject {
    func didSelectEpisode(_ episode: TVShowEpisode)
}

// MARK: - TVShowDetailsViewModel

final class TVShowDetailsViewModel: TVShowDetailsViewModelProtocol {
    // MARK: Lifecycle

    init(
        show: TVShow,
        apiService: TVMazeServiceProtocol,
        imageLoader: ImageLoading,
        persistentStorage: DataPersisting
    ) {
        self.show = show
        self.apiService = apiService
        self.imageLoader = imageLoader
        self.persistentStorage = persistentStorage
    }

    // MARK: Internal

    weak var delegate: TVShowDetailsViewModelDelegate?

    let show: TVShow
    private(set) var imageData: Data?
    private(set) var episodes: [TVShowEpisode]?
    private(set) var isShowInFavorites: Bool = false

    func fetchData() async {
        async let _ = await fetchImage()
        async let _ = await fetchEpisodes()
        isShowInFavorites = persistentStorage.isShowInFavorites(id: show.id)
    }

    func handleFavoriteButtonTapped() {
        if !isShowInFavorites {
            if case let .failure(error) = persistentStorage.addToFavorites(show) {
                print("Failed to add show \(show.id) to favorites with error \(error)")
            }
        } else {
            if case let .failure(error) = persistentStorage.removeFromFavorites(id: show.id) {
                print("Failed to remove show \(show.id) from favorites with error \(error)")
            }
        }

        isShowInFavorites = persistentStorage.isShowInFavorites(id: show.id)
    }

    // MARK: Private

    private func fetchImage() async {
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

    private func fetchEpisodes() async {
        let request = TVMazeRequest(endpoint: .shows, pathComponents: [.id(show.id), .episodes], queryItems: nil)
        switch await apiService.execute(request, expecting: [TVShowEpisode].self) {
            case .success(let episodes):
                self.episodes = episodes
            case .failure(let error):
                print("Failed to fetch shows with error \(error)")
        }
    }

    private let imageLoader: ImageLoading
    private let apiService: TVMazeServiceProtocol
    private let persistentStorage: DataPersisting
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
