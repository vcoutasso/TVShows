import XCTest

@testable import TVShows

@MainActor
final class TVShowsListViewTests: XCTestCase {
    
    private let viewModelSpy = TVShowsListViewModelSpy()
    private let collectionAdapterSpy = TVShowListViewCollectionViewAdapterSpy()
    private lazy var sut = TVShowsListView(viewModel: viewModelSpy, collectionAdapter: collectionAdapterSpy)

    func testShouldFetchInitialPageOnInit() {
        // Given
        viewModelSpy.expectation = expectation(description: "Should fetch initial page")
        XCTAssertFalse(viewModelSpy.didFetchInitialPage)

        // When
        _ = sut
        waitForExpectations(timeout: 1)

        // Then
        XCTAssertTrue(viewModelSpy.didFetchInitialPage)
    }
}
