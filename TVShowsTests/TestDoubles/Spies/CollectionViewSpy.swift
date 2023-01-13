import UIKit

final class CollectionViewSpy: UICollectionView {
    init() {
        super.init(frame: .zero, collectionViewLayout: .init())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private(set) var didReloadData = false
    override func reloadData() {
        didReloadData = true
    }

    private(set) var didInsertItemsAtIndexPath: [IndexPath]?
    override func insertItems(at indexPaths: [IndexPath]) {
        didInsertItemsAtIndexPath = indexPaths
    }
}
