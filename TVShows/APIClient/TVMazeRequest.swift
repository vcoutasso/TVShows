import Foundation

protocol TVMazeRequestProtocol {
    init(endpoint: TVMazeEndpoint, pathComponents: [String]?, queryItems: [URLQueryItem]?)

    var endpoint: TVMazeEndpoint { get }
    var url: URL? { get }

    func urlRequest() -> URLRequest?
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

    func urlRequest() -> URLRequest? {
        guard let requestUrl = url else { return nil }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = httpMethod

        return request
    }

    // MARK: Private

    private let baseURL: String = "https://api.tvmaze.com/"
    private let httpMethod: String = "GET"

    private let pathComponents: [String]
    private let queryItems: [URLQueryItem]
}
