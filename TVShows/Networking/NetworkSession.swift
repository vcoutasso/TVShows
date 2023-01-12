import Foundation

// MARK: - NetworkSession

final class NetworkSession: NetworkRequesting {
    // MARK: Lifecycle

    init(urlSession: any NetworkSessionURLSession) {
        self.urlSession = urlSession
    }

    // MARK: Internal

    static let `default`: NetworkSession = .init(urlSession: URLSession.shared)

    let urlSession: any NetworkSessionURLSession

    func execute(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await urlSession.data(for: request)
    }
}
