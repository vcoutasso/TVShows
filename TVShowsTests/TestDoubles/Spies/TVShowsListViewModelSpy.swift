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

    var expectation: XCTestExpectation?

    private(set) var displayedCellViewModels: [TVShowsListCollectionViewCellViewModelProtocol] = []


    private(set) var didFetchInitialPage = false
    func fetchInitialPage() async {
        didFetchInitialPage = true
        expectation?.fulfill()
    }

    func searchShows(with query: String) async {

    }

    func cancelSearch() {
        
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
