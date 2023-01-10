import Foundation

enum Fixtures {
    static let mockURL: URL = URL(string: "http://localhost/")!

    static let mockNSError: NSError = NSError(domain: "", code: .zero)

    static let mockURLRequest: URLRequest = URLRequest(url: mockURL)

    static let mockURLResponse: URLResponse = URLResponse(url: mockURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)

    static func mockHTTPURLResponse(statusCode: Int = 200) -> HTTPURLResponse {
        HTTPURLResponse(url: mockURL, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: nil)!

    }
}
