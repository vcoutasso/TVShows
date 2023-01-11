import Foundation
import XCTest

@testable import TVShows

final class TVShowsListCollectionViewCellViewModelSpy: TVShowsListCollectionViewCellViewModelProtocol {
    // MARK: Lifecycle

    init(show: TVShow, imageLoader: ImageLoading) {
        self.show = show
        self.imageLoader = imageLoader
    }

    // MARK: Internal

    var show: TVShow
    var imageData: Data?

    var expectation: XCTestExpectation?

    private(set) var didFetchImage = false
    func fetchImage() async {
        didFetchImage = true
        expectation?.fulfill()
    }

    // MARK: Private

    private let imageLoader: ImageLoading
}
