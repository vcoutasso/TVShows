import XCTest

@testable import TVShows

@MainActor
final class TVShowsListViewModelTests: XCTestCase {

    private let serviceSpy = TVMazeAPIServiceSpy<[TVShow]>()
    private lazy var sut = TVShowsListViewModel(mazeAPIService: serviceSpy)

    func testFetchInitialPageShouldExecuteTVMazeService() async {
        // Given
        XCTAssertFalse(serviceSpy.didExecute)

        // When
        await sut.fetchInitialPage()

        // Then
        XCTAssertTrue(serviceSpy.didExecute)
    }

    func testFetchInitialPageShouldMapResultsToViewModels() async {
        // Given
        XCTAssertTrue(sut.cellViewModels.count == 0)
        serviceSpy.dataStub = [Fixtures.mockTVShow]

        // When
        await sut.fetchInitialPage()

        // Then
        XCTAssertFalse(sut.cellViewModels.count == 0)
    }

    func testFetchNextPageShouldNotExecuteServiceAfterReceivingCode404() async {
        // Given
        let mirror = Mirror(reflecting: sut)
        XCTAssertEqual(mirror.children.first(where: { $0.label == "canLoadMorePages"})?.value as? Bool, true)
        serviceSpy.errorStub = TVMazeService.TVMazeServiceError.noMoreData
        XCTAssertEqual(serviceSpy.executeCallCount, 0)

        // When
        // This call returns the expected error, which should prevent subsequent fetch tries
        await sut.fetchNextPage()
        serviceSpy.dataStub = []
        await sut.fetchNextPage()

        // Then
        XCTAssertEqual(mirror.children.first(where: { $0.label == "canLoadMorePages"})?.value as? Bool, false)
        XCTAssertEqual(serviceSpy.executeCallCount, 1)
    }

    func testFetchNextPageShouldTryAgainAfterExceedingRateLimit() async throws {
        // Given
        XCTAssertEqual(serviceSpy.executeCallCount, 0)
        serviceSpy.errorStub = TVMazeService.TVMazeServiceError.exceededAPIRateLimit

        // When
        await sut.fetchNextPage()
        try await Task.sleep(nanoseconds: 2 *  TVShowsListViewModel.Constants.delayBetweenRetries)

        // Then
        XCTAssertEqual(serviceSpy.executeCallCount, 2)
    }

    func testFetchNextPageShouldIncrementPageCountOnSuccess() async {
        // Given
        let mirror = Mirror(reflecting: sut)
        XCTAssertEqual(mirror.children.first(where: { $0.label == "nextPage"})?.value as? Int, 1)
        serviceSpy.dataStub = []

        // When
        await sut.fetchNextPage()

        // Then
        XCTAssertEqual(mirror.children.first(where: { $0.label == "nextPage"})?.value as? Int, 2)
    }

    func testFetchNextPageShouldCallDelegateWithIndexPathsToAddOnSuccess() async {
        // Given
        let delegateSpy = TVShowsListViewModelDelegateSpy()
        sut.delegate = delegateSpy
        serviceSpy.dataStub = [Fixtures.mockTVShow, Fixtures.mockTVShow]
        let expectedIndexPaths: [IndexPath] = [.init(row: 0, section: 0), .init(row: 1, section: 0)]

        // When
        await sut.fetchNextPage()

        // Then
        XCTAssertEqual(expectedIndexPaths, delegateSpy.receivedDidFetchNextPageWithIndexPathsToAdd)
    }
}
