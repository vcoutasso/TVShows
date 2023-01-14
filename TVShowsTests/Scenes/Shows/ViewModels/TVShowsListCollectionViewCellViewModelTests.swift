import XCTest

@testable import TVShows

@MainActor
final class TVShowsListCollectionViewCellViewModelTests: XCTestCase {
    private let imageLoaderStub = ImageLoaderStub()
    private lazy var sut = TVShowsListCollectionViewCellViewModel(show: Fixtures.mockTVShow, imageLoader: imageLoaderStub)

    func testFetchImageShouldCallImageLoaderWhenDataIsValid() async throws {
        // Given
        let image = try XCTUnwrap(sut.show.image)
        XCTAssertNotNil(URL(string: image.medium))
        XCTAssertFalse(imageLoaderStub.didFetchImageData)

        // When
        await sut.fetchImage()

        // Then
        XCTAssertTrue(imageLoaderStub.didFetchImageData)
    }

    func testShouldNotFetchDataWhenImageIsNil() async {
        // Given
        let sut = TVShowsListCollectionViewCellViewModel(show: Fixtures.mockTVShowWithoutImage, imageLoader: imageLoaderStub)
        XCTAssertNil(sut.show.image)
        XCTAssertFalse(imageLoaderStub.didFetchImageData)

        // When
        await sut.fetchImage()

        // Then
        XCTAssertFalse(imageLoaderStub.didFetchImageData)
    }

    func testShouldNotFetchDataWhenImageURLIsNotValid() async {
        // Given
        let sut = TVShowsListCollectionViewCellViewModel(show: Fixtures.mockTVShowWithInvalidURLs, imageLoader: imageLoaderStub)
        XCTAssertFalse(imageLoaderStub.didFetchImageData)

        // When
        await sut.fetchImage()

        // Then
        XCTAssertFalse(imageLoaderStub.didFetchImageData)
    }
}
