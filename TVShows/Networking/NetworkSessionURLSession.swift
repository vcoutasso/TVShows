import Foundation

protocol NetworkSessionURLSession: Sendable {
    func data(for: URLRequest) async throws -> (Data, URLResponse)
}
