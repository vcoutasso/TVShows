import XCTest

@testable import TVShows

@MainActor
final class TVShowsListViewModelTests: XCTestCase {

    private let serviceSpy = TVMazeAPIServiceSpy<Int>()
    private lazy var sut = TVShowsListViewModel(mazeAPIService: serviceSpy)

    func testFetchInitialPageShouldExecuteTVMazeService() async {
        // Given
        XCTAssertFalse(serviceSpy.didExecute)

        // When
        await sut.fetchInitialPage()

        // Then
        XCTAssertTrue(serviceSpy.didExecute)
    }
}
