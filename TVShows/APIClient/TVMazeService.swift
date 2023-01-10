import Foundation

protocol TVMazeServiceProtocol: AnyObject {
    var apiRequestService: NetworkRequesting { get }

    func execute<T: Codable>(_ request: TVMazeRequest, expecting type: T.Type) async -> Result<T, Error>
}

final class TVMazeService: TVMazeServiceProtocol {
    // MARK: Lifecycle

    private init(apiRequestService: NetworkRequesting = NetworkSession.default) {
        self.apiRequestService = apiRequestService
    }

    // MARK: Internal

    static let shared: TVMazeService = .init()

    func execute<T: Codable>(_ request: TVMazeRequest, expecting type: T.Type) async -> Result<T, Error> {
        guard let urlRequest = request.urlRequest() else {
            return .failure(TVMazeServiceError.failedToGetURLRequest)
        }

        do {
            let (data, response) = try await apiRequestService.execute(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 429 {
                return .failure(TVMazeServiceError.exceededAPIRateLimit)
            }

            let decodedData = try JSONDecoder().decode(T.self, from: data)

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
    }

    private(set) var apiRequestService: NetworkRequesting
}
