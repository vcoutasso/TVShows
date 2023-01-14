import XCTest

@testable import TVShows

@MainActor
final class TVShowEpisodeDetailsViewModelTests: XCTestCase {

    private let mockEpisode = Fixtures.mockTVShowEpisodeWithImage
    private let imageLoaderStub = ImageLoaderStub()
    private lazy var sut = TVShowEpisodeDetailsViewModel(episode: mockEpisode, imageLoader: imageLoaderStub)

    func testFetchImageShouldCallImageLoader() async {
        // Given
        XCTAssertFalse(imageLoaderStub.didFetchImageData)

        // When
        await sut.fetchImage()

        // Then
        XCTAssertTrue(imageLoaderStub.didFetchImageData)
    }
}
