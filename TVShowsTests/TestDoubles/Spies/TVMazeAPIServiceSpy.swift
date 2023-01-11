import Foundation

@testable import TVShows

final class TVMazeAPIServiceSpy<T: Codable>: TVMazeServiceProtocol {
    // MARK: Lifecycle

    init() {}
    init(jsonDecoder: JSONDecoding, networkService: NetworkRequesting) {}

    // MARK: Internal

    var dataStub: T?
    var errorStub: Error = Fixtures.mockNSError

    private(set) var didExecute = false
    func execute<T>(_ request: TVShows.TVMazeRequest, expecting type: T.Type) async -> Result<T, Error> where T : Decodable, T : Encodable {
        didExecute = true
        if let dataStub = dataStub as? T {
            return .success(dataStub)
        }

        return .failure(errorStub)
    }
}
