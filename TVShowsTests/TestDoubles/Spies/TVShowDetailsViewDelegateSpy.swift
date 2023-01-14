import UIKit

@testable import TVShows

final class TVShowDetailsViewDelegateSpy: NSObject, TVShowDetailsViewDelegate {
    private(set) var didPresentEpisodeDetails = false
    func presentEpisodeDetails(_ episode: TVShows.TVShowEpisode) {
        didPresentEpisodeDetails = true
    }

    private(set) var didUpdateRightBarButtonImage = false
    func updateRightBarButtonImage(with image: UIImage) {
        didUpdateRightBarButtonImage = true
    }
}
