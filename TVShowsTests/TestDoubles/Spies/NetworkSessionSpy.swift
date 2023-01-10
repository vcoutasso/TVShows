import Foundation

@testable import TVShows

final class NetworkSessionSpy: NetworkRequesting {
    // MARK: Lifecycle

    init(urlSession: any NetworkSessionURLSession) {
        self.urlSession = urlSession
    }

    // MARK: Internal

    private(set) var urlSession: any NetworkSessionURLSession

    private(set) var didExecuteService: Bool = false
    func execute(for request: URLRequest) async throws -> (Data, URLResponse) {
        didExecuteService = true
        return try await urlSession.data(for: request)
    }
}
