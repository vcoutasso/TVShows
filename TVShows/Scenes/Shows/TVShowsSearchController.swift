import UIKit
import Combine

// MARK: - TVShowsSearchControllerProtocol

@MainActor
protocol TVShowsSearchControllerProtocol: UISearchBarDelegate {
    var searchBarSubject: PassthroughSubject<TVShowsSearchController.SearchEvent, Never> { get }
}

// MARK: - TVShowsSearchController

final class TVShowsSearchController: UISearchController, TVShowsSearchControllerProtocol {

    // MARK: Internal

    private(set) var searchBarSubject: PassthroughSubject<TVShowsSearchController.SearchEvent, Never> = .init()

    enum SearchEvent {
        case receivedQuery(String)
        case cancelledSearch
    }
}

extension TVShowsSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty { searchBarSubject.send(.receivedQuery(searchText)) }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarSubject.send(.cancelledSearch)
    }
}
