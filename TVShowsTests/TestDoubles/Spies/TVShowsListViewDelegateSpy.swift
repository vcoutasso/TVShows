import Foundation

@testable import TVShows

final class TVShowsListViewDelegateSpy: TVShowsListViewDelegate {
    private(set) var didPresentShowDetails = false
    func presentShowDetails(_ show: TVShow) {
        didPresentShowDetails = true
    }
}
