import Foundation

@testable import TVShows

final class TVShowsListViewModelDelegateSpy: TVShowsListViewModelDelegate {
    private(set) var receivedDidFetchNextPageWithIndexPathsToAdd: [IndexPath]?
    func didFetchNextPage(with indexPathsToAdd: [IndexPath]) {
        receivedDidFetchNextPageWithIndexPathsToAdd = indexPathsToAdd
    }

    func didSearchShows() {
    }
}
