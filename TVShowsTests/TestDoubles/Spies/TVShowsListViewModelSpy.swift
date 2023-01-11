import Foundation
import XCTest
import UIKit

@testable import TVShows

final class TVShowsListViewModelSpy: NSObject, TVShowsListViewModelProtocol {

    // MARK: Lifecycle

    override init() {}
    init(mazeAPIService: TVMazeServiceProtocol) {}

    // MARK: Internal

    weak var delegate: TVShowsListViewModelDelegate?

    var expectation: XCTestExpectation?

    private(set) var cellViewModels: NSMutableOrderedSet = .init()

    private(set) var didFetchInitialPage = false
    func fetchInitialPage() async {
        didFetchInitialPage = true
        expectation?.fulfill()
    }

    private(set) var didFetchNextPageCount = 0
    func fetchNextPage() async {
        didFetchNextPageCount += 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}
