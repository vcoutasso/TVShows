import Foundation

@testable import TVShows

final class TVShowDetailsViewModelSpy: TVShowDetailsViewModelProtocol, TVShowDetailsViewCollectionViewAdapterDelegate {

    init(show: TVShow) {
        self.show = show
    }

    var delegate: TVShowDetailsViewModelDelegate?

    var show: TVShow

    var imageData: Data?

    var episodes: [TVShowEpisode]?

    var isShowInFavorites: Bool = false

    private(set) var didFetchData = false
    func fetchData() async {
        didFetchData = true
    }

    private(set) var didHandleFavoriteButtonTap = false
    func handleFavoriteButtonTapped() {
        didHandleFavoriteButtonTap = true
    }

    private(set) var didFetchEpisodeName = false
    func episodeName(season: Int, episode: Int) -> String? {
        didFetchEpisodeName = true
        return nil
    }

    private(set) var didSelectCellAtIndexPath: IndexPath?
    func didSelectCell(at indexPath: IndexPath) {
        didSelectCellAtIndexPath = indexPath
    }
}
