import Foundation

protocol TVMazeRequestProtocol {
    init(endpoint: TVMazeEndpoint, pathComponents: [String]?, queryItems: [URLQueryItem]?)

    var endpoint: TVMazeEndpoint { get }
    var url: URL? { get }
}

struct TVMazeRequest: TVMazeRequestProtocol {
    // MARK: Lifecycle

    init(endpoint: TVMazeEndpoint, pathComponents: [String]?, queryItems: [URLQueryItem]?) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents ?? []
        self.queryItems = queryItems ?? []
    }

    // MARK: Internal

    let endpoint: TVMazeEndpoint

    var url: URL? {
        guard let urlComponents = URLComponents(string: baseURL + endpoint.rawValue) else { return nil }

        return urlComponents.url
            .map {
                pathComponents.isEmpty ? $0 : $0.appending(component: pathComponents.joined(separator: "/"))
            }
            .map {
                queryItems.isEmpty ? $0 : $0.appending(queryItems: queryItems)
            }
    }

    // MARK: Private

    private let baseURL: String = "https://api.tvmaze.com/"

    private let pathComponents: [String]
    private let queryItems: [URLQueryItem]
}