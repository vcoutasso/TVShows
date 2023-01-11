import Foundation

protocol TVMazeServiceProtocol: AnyObject {
    init(jsonDecoder: JSONDecoding, networkService: NetworkRequesting)

    func execute<T: Codable>(_ request: TVMazeRequest, expecting type: T.Type) async -> Result<T, Error>
}

final class TVMazeService: TVMazeServiceProtocol {
    // MARK: Lifecycle

    init(jsonDecoder: JSONDecoding, networkService: NetworkRequesting) {
        self.jsonDecoder = jsonDecoder
        self.networkService = networkService
    }

    static let `default`: TVMazeService = .init(jsonDecoder: JSONDecoder(), networkService: NetworkSession.default)

    // MARK: Internal

    func execute<T: Codable>(_ request: TVMazeRequest, expecting type: T.Type) async -> Result<T, Error> {
        guard let urlRequest = request.urlRequest() else {
            return .failure(TVMazeServiceError.failedToGetURLRequest)
        }

        do {
            let (data, response) = try await networkService.execute(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 429 {
                    return .failure(TVMazeServiceError.exceededAPIRateLimit)
                } else if httpResponse.statusCode == 404 {
                    return .failure(TVMazeServiceError.noMoreData)
                }
            }

            let decodedData = try jsonDecoder.decode(T.self, from: data)

            return .success(decodedData)
        } catch {
            return .failure(error)
        }
    }

    enum TVMazeServiceError: Error {
        /// Failed to get `URLRequest` from `TVMazeRequest`
        case failedToGetURLRequest
        /// Exceeded limit of API calls. This is not a permanent failure, retrying after a small pause is encouraged
        case exceededAPIRateLimit
        /// Reached the end of the list
        case noMoreData
    }

    private let networkService: NetworkRequesting
    private let jsonDecoder: JSONDecoding
}
