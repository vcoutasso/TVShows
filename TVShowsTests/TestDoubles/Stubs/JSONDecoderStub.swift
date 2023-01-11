import Foundation

@testable import TVShows

final class JSONDecoderStub<T: Decodable>: JSONDecoding {
    // MARK: Internal

    var decodedDataStub: T?
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        decodedDataStub as! T
    }
}
