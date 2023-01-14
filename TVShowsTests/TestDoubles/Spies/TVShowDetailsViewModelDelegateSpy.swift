import Foundation

@testable import TVShows

final class TVShowDetailsViewModelDelegateSpy: TVShowDetailsViewModelDelegate {
    private(set) var selectedEpisode: TVShowEpisode?
    func didSelectEpisode(_ episode: TVShowEpisode) {
        selectedEpisode = episode
    }
}
