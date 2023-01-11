import XCTest

@testable import TVShows

@MainActor
final class TVShowsListViewTests: XCTestCase {
    
    private let viewModelSpy = TVShowsListViewModelSpy()
    private lazy var sut = TVShowsListView(viewModel: viewModelSpy)

    func testTVShowsListViewShouldFetchInitialPageOnInit() {
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
