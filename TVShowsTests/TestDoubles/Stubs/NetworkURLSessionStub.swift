import Foundation

@testable import TVShows

final class NetworkURLSessionStub: NetworkSessionURLSession {
    // MARK: Internal

    var resultData: Data?
    var resultResponse: URLResponse?
    var resultError = Fixtures.mockNSError

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        guard let resultData, let resultResponse else {
            throw resultError
        }

        return (resultData, resultResponse)
    }

    // MARK: Private

    private static let dummyURL: URL = URL(string: ".")!
}
