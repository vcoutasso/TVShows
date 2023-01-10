import Foundation

@MainActor
protocol TVShowsListViewModelProtocol {
    init(mazeAPIService: TVMazeServiceProtocol)

    var shows: [TVShow] { get }

    func fetchInitialPage() async
    func fetchNextPage() async
}

final class TVShowsListViewModel: TVShowsListViewModelProtocol {
    // MARK: Lifecycle

    init(mazeAPIService: TVMazeServiceProtocol = TVMazeService(jsonDecoder: JSONDecoder(), networkService: NetworkSession.default)) {
        self.mazeAPIService = mazeAPIService
        self.shows = []
    }

    // MARK: Internal

    private(set) var shows: [TVShow]

    func fetchInitialPage() async {
        let request = TVMazeRequest(endpoint: .shows, pathComponents: nil, queryItems: nil)
        switch await self.mazeAPIService.execute(request, expecting: [TVShow].self) {
            case .success(let shows):
                self.shows.append(contentsOf: shows)
            case .failure(let error):
                print("Failed to fetch shows with error \(error)")
        }
    }

    func fetchNextPage() async {

    }

    // MARK: Private

    private let mazeAPIService: TVMazeServiceProtocol
}
