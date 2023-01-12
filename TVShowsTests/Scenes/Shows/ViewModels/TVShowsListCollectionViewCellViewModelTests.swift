import XCTest

@testable import TVShows

@MainActor
final class TVShowsListCollectionViewCellViewModelTests: XCTestCase {
    private let imageLoaderStub = ImageLoaderStub()
    private lazy var sut = TVShowsListCollectionViewCellViewModel(show: Fixtures.mockTVShow, imageLoader: imageLoaderStub)

    func testFetchImageShouldCallImageLoader() async {
        // Given
        XCTAssertFalse(imageLoaderStub.didFetchImageData)

        // When
        await sut.fetchImage()

        // Then
        XCTAssertTrue(imageLoaderStub.didFetchImageData)
    }
}
