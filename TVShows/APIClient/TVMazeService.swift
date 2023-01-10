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
            let (data, _) = try await urlSession.data(for: urlRequest)
            let decodedData = try JSONDecoder().decode(T.self, from: data)

            return .success(decodedData)
        } catch {
            return .failure(error)
        }
    }

    enum TVMazeServiceError: Error {
        case failedToGetURLRequest
    }

    // MARK: Private

    private let urlSession = URLSession.shared
}
