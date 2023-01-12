import Foundation

// MARK: - NetworkRequesting

protocol NetworkRequesting: AnyObject, Sendable {
    var urlSession: any NetworkSessionURLSession { get }

    func execute(for request: URLRequest) async throws -> (Data, URLResponse)
}
