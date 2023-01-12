import UIKit
import Combine

// MARK: - TVShowsSearchControllerProtocol

@MainActor
protocol TVShowsListSearchControllerProtocol: UISearchBarDelegate {
    var searchBarSubject: PassthroughSubject<TVShowsListSearchController.SearchEvent, Never> { get }
}

// MARK: - TVShowsSearchController

final class TVShowsListSearchController: UISearchController, TVShowsListSearchControllerProtocol {

    // MARK: Internal

    private(set) var searchBarSubject: PassthroughSubject<TVShowsListSearchController.SearchEvent, Never> = .init()

    enum SearchEvent {
        case receivedQuery(String)
        case cancelledSearch
    }
}

extension TVShowsListSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty { searchBarSubject.send(.receivedQuery(searchText)) }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarSubject.send(.cancelledSearch)
    }
}
