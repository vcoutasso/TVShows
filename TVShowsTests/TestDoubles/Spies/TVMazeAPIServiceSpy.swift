import Foundation

@testable import TVShows

final class TVMazeAPIServiceSpy<T: Codable>: TVMazeServiceProtocol {
    // MARK: Lifecycle

    init() {}
    init(jsonDecoder: JSONDecoding, networkService: NetworkRequesting) {}

    // MARK: Internal

    var dataStub: T?
    var errorStub: Error = Fixtures.mockNSError


    var didExecute: Bool { executeCallCount > 0 }
    private(set) var executeCallCount = 0
    func execute<T>(_ request: TVShows.TVMazeRequest, expecting type: T.Type) async -> Result<T, Error> where T : Decodable, T : Encodable {
        executeCallCount += 1
        if let dataStub = dataStub as? T {
            return .success(dataStub)
        }

        return .failure(errorStub)
    }
}
