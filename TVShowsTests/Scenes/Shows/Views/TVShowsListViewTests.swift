import XCTest

@testable import TVShows

@MainActor
final class TVShowsListViewTests: XCTestCase {

    // MARK: Dependencies + SUT
    
    private let viewModelSpy = TVShowsListViewModelSpy()
    private let collectionAdapterSpy = TVShowListViewCollectionViewAdapterSpy()
    private let collectionViewSpy = CollectionViewSpy()
    private let delegateSpy = TVShowsListViewDelegateSpy()
    private lazy var sut = TVShowsListView(viewModel: viewModelSpy, collectionView: collectionViewSpy, collectionAdapter: collectionAdapterSpy)

    // MARK: Set up tests

    override func setUp() {
        super.setUp()
        sut.delegate = delegateSpy
    }

    // MARK: Tests

    func testShouldFetchInitialPageOnInit() {
        // Given
        viewModelSpy.fetchInitialPageExpectation = expectation(description: "Should fetch initial page")
        XCTAssertFalse(viewModelSpy.didFetchInitialPage)

        // When
        _ = sut
        waitForExpectations(timeout: 2)

        // Then
        XCTAssertTrue(viewModelSpy.didFetchInitialPage)
    }

    func testSearchShowsShouldRequestFromViewModel() {
        // Given
        viewModelSpy.searchShowsExpectation = expectation(description: "Should search shows")
        XCTAssertFalse(viewModelSpy.didSearchShows)

        // When
        sut.searchShows(with: "")
        waitForExpectations(timeout: 2)

        // Then
        XCTAssertTrue(viewModelSpy.didSearchShows)
    }

    func testClearFiltersShouldCancelSearch() {
        // Given
        XCTAssertFalse(viewModelSpy.didCancelSearch)

        // When
        sut.clearFilters()

        // Then
        XCTAssertTrue(viewModelSpy.didCancelSearch)
    }

    func testClearFiltersShouldReloadCollectionViewData() {
        // Given
        XCTAssertFalse(collectionViewSpy.didReloadData)

        // When
        sut.clearFilters()

        // Then
        XCTAssertTrue(collectionViewSpy.didReloadData)
    }

    func testDidFetchNextPageShouldInsertItemsAtIndexPath() {
        // Given
        let indexPaths: [IndexPath] = [
            .init(row: 0, section: 0),
            .init(row: 0, section: 1),
            .init(row: 0, section: 2),
        ]
        XCTAssertNil(collectionViewSpy.didInsertItemsAtIndexPath)

        // When
        sut.didFetchNextPage(with: indexPaths)

        // Then
        XCTAssertEqual(indexPaths, collectionViewSpy.didInsertItemsAtIndexPath)
    }

    func testDidFetchFilterShowsShouldReloadCollectionViewData() {
        // Given
        XCTAssertFalse(collectionViewSpy.didReloadData)

        // When
        sut.didFetchFilteredShows()

        // Then
        XCTAssertTrue(collectionViewSpy.didReloadData)
    }

    func testDidSelectCellShouldPresentDelegateShowDetails() {
        // Given
        XCTAssertFalse(delegateSpy.didPresentShowDetails)

        // When
        sut.didSelectCell(for: Fixtures.mockTVShow)

        // Then
        XCTAssertTrue(delegateSpy.didPresentShowDetails)
    }
}
