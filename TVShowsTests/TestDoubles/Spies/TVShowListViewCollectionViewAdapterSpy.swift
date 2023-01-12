import UIKit

@testable import TVShows

final class TVShowListViewCollectionViewAdapterSpy: NSObject, TVShowListViewCollectionViewAdapterProtocol {
    var delegate: TVShows.TVShowListViewCollectionViewAdapterDelegate?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}
