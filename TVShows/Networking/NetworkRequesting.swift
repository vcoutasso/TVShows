import Foundation

protocol NetworkRequesting: AnyObject {
    var urlSession: any NetworkSessionURLSession { get }

    func execute(for request: URLRequest) async throws -> (Data, URLResponse)
}
