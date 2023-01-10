import Foundation

protocol NetworkSessionURLSession {
    func data(for: URLRequest) async throws -> (Data, URLResponse)
}
