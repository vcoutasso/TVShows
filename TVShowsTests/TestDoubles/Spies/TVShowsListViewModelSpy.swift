import Foundation
import XCTest
import UIKit

@testable import TVShows

final class TVShowsListViewModelSpy: NSObject, TVShowsListViewModelProtocol, TVShowListViewCollectionViewAdapterDelegate {
    // MARK: Lifecycle

    override init() {}
    init(apiService: TVMazeServiceProtocol) {}

    // MARK: Internal

    weak var delegate: TVShowsListViewModelDelegate?


    private(set) var displayedCellViewModels: [TVShowsListCollectionViewCellViewModelProtocol] = []


    private(set) var didFetchInitialPage = false
    var fetchInitialPageExpectation: XCTestExpectation?
    func fetchInitialPage() async {
        didFetchInitialPage = true
        fetchInitialPageExpectation?.fulfill()
    }

    private(set) var didSearchShows = false
    var searchShowsExpectation: XCTestExpectation?
    func searchShows(with query: String) async {
        didSearchShows = true
        searchShowsExpectation?.fulfill()
    }

    private(set) var didCancelSearch = false
    func cancelSearch() {
        didCancelSearch = true
    }

    private(set) var didFetchNextPageCount = 0
    func fetchNextPage() async {
        didFetchNextPageCount += 1
    }

    var shouldDisplayLoadingFooter: Bool {
        false
    }

    func didSelectCell(at indexPath: IndexPath) {
    }

    func didScrollPastCurrentContent() {
    }
}
