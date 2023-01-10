import Foundation

final class TVMazeService {
    // MARK: Lifecycle

    private init() {}

    // MARK: Internal

    static let shared: TVMazeService = .init()

    func execute<T: Codable>(_ request: TVMazeRequest, expecting type: T.Type) async -> Result<T, Error> {
        guard let urlRequest = request.urlRequest() else {
            return .failure(TVMazeServiceError.failedToGetURLRequest)
        }

        do {
            let (data, response) = try await urlSession.data(for: urlRequest)

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

    // MARK: Private

    private let urlSession = URLSession.shared
}
