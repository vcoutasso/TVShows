import Foundation

protocol JSONDecoding {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}
