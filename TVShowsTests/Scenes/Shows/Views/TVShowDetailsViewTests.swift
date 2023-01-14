import XCTest

@testable import TVShows

@MainActor
final class TVShowDetailsViewTests: XCTestCase {

    private let delegateSpy = TVShowDetailsViewDelegateSpy()
    private let collectionAdapterSpy = TVShowDetailsViewCollectionViewAdapterSpy(show: Fixtures.mockTVShow, sections: [])
    private let viewModelSpy = TVShowDetailsViewModelSpy(show: Fixtures.mockTVShow)
    private lazy var sut = TVShowDetailsView(viewModel: viewModelSpy, collectionAdapter: collectionAdapterSpy)

    override func setUp() {
        super.setUp()
        sut.delegate = delegateSpy
    }

    func testDidTapFavoriteButtonShouldCallViewModelHandler() {
        // Given
        XCTAssertFalse(viewModelSpy.didHandleFavoriteButtonTap)

        // When
        sut.didTapFavoriteButton()

        // Then
        XCTAssertTrue(viewModelSpy.didHandleFavoriteButtonTap)
    }

    func testDidTapFavoriteButtonShouldUpdateDelegateRightBarButtonImage() {
        // Given
        XCTAssertFalse(delegateSpy.didUpdateRightBarButtonImage)

        // When
        sut.didTapFavoriteButton()

        // Then
        XCTAssertTrue(delegateSpy.didUpdateRightBarButtonImage)
    }

    func testDidSelectEpisodeShouldPresentDelegateEpisodeDetails() {
        // Given
        XCTAssertFalse(delegateSpy.didPresentEpisodeDetails)

        // When
        sut.didSelectEpisode(Fixtures.mockTVShowEpisodeS01E01)

        // Then
        XCTAssertTrue(delegateSpy.didPresentEpisodeDetails)
    }
}
