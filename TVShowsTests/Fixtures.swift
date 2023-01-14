import Foundation

@testable import TVShows

enum Fixtures {
    static let mockURL: URL = URL(string: "http://localhost/")!

    static let mockNSError: NSError = NSError(domain: "", code: .zero)

    static let mockURLRequest: URLRequest = URLRequest(url: mockURL)

    static let mockURLResponse: URLResponse = URLResponse(url: mockURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)

    static let mockTVShow: TVShow = .init(id: 0, name: "", genres: [], schedule: .init(time: "", days: []), status: "", rating: .init(average: 5), summary: "", image: .init(medium: mockURL.absoluteString, original: mockURL.absoluteString))

    static let mockTVShowWithInvalidURLs: TVShow = .init(id: 0, name: "", genres: [], schedule: .init(time: "", days: []), status: "", rating: .init(average: 5), summary: "", image: .init(medium: "", original: ""))

    static let mockTVShowWithoutImage: TVShow = .init(id: 0, name: "", genres: [], schedule: .init(time: "", days: []), status: "", rating: .init(average: 5), summary: "", image: nil)

    static let mockTVShowEpisodeS01E01: TVShowEpisode = .init(id: 1, name: "Season 01 Episode 01", season: 1, number: 1, summary: "", image: nil)

    static let mockTVShowEpisodeS02E02: TVShowEpisode = .init(id: 2, name: "Season 02 Episode 02", season: 2, number: 2, summary: "", image: nil)

    static let mockTVShowEpisodeWithImage: TVShowEpisode = .init(id: 14, name: "Season 03 Episode 07", season: 3, number: 7, summary: "", image: .init(medium: mockURL.absoluteString, original: mockURL.absoluteString))

    static func mockHTTPURLResponse(statusCode: Int = 200) -> HTTPURLResponse {
        HTTPURLResponse(url: mockURL, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: nil)!
    }

    enum EquatableError: Equatable, Error {
        case error
    }
}
