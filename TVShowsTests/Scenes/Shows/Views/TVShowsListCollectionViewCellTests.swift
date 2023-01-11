import XCTest

@testable import TVShows

@MainActor
final class TVShowsListCollectionViewCellTests: XCTestCase {
    private let imageLoadingStub = ImageLoaderStub()
    private lazy var viewModelSpy = TVShowsListCollectionViewCellViewModelSpy(show: Fixtures.mockTVShow, imageLoader: imageLoadingStub)
    private lazy var sut = TVShowsListCollectionViewCell()

    func testTVShowsListCollectionViewCellShouldFetchDataWhenViewModelDataIsNil() {
        // Given
        XCTAssertNil(viewModelSpy.imageData)
        viewModelSpy.expectation = expectation(description: "Should fetch image data")

        // When
        sut.configure(with: viewModelSpy)
        waitForExpectations(timeout: 1)

        // Then
        XCTAssertTrue(viewModelSpy.didFetchImage)
    }

    func testTVShowsListCollectionViewCellShouldNotFetchDataWhenViewModelDataIsPresent() {
        // Given
        viewModelSpy.imageData = Data()

        // When
        sut.configure(with: viewModelSpy)

        // Then
        XCTAssertFalse(viewModelSpy.didFetchImage)
    }
}
