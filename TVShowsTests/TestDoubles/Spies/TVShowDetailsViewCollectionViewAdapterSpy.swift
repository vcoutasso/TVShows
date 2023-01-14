import UIKit

@testable import TVShows

final class TVShowDetailsViewCollectionViewAdapterSpy: NSObject, TVShowDetailsViewCollectionViewAdapterProtocol {

    init(show: TVShow, sections: [TVShowDetailsViewCollectionSections]) {
        self.show = show
        self.sections = sections
    }

    var delegate: TVShows.TVShowDetailsViewCollectionViewAdapterDelegate?

    var show: TVShow

    var sections: [TVShowDetailsViewCollectionSections]

    var stretchyHeaderImage: UIImage?

    private(set) var didUpdateSectionsWithEpisodes: [TVShowEpisode]?
    func updateSectionsWithEpisodes(_ episodes: [TVShowEpisode]) {
        didUpdateSectionsWithEpisodes = episodes
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}
