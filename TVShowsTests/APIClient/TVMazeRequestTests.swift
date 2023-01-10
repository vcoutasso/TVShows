import XCTest

@testable import TVShows

final class TVMazeRequestTests: XCTestCase {
    private let testBundle = Bundle(for: TVMazeRequestTests.self)

    func testTVMazeRequestYieldsValidURLRequest() {
        // Given
        let endpoint = TVMazeEndpoint.shows
        let request = TVMazeRequest(endpoint: endpoint, pathComponents: nil, queryItems: nil)

        // When
        let urlRequest = request.urlRequest()

        // Then
        XCTAssertNotNil(urlRequest)
    }

    func testTVMazeRequestShouldProduceValidShowsURL() {
        // Given
        let endpoint = TVMazeEndpoint.shows
        let request = TVMazeRequest(endpoint: endpoint, pathComponents: nil, queryItems: nil)

        // When
        let url = request.url

        // Then
        XCTAssertEqual(url?.absoluteString, "https://api.tvmaze.com/shows")
    }

    func testTVMazeRequestShouldProduceValidShowsWithEmbeddingURL() {
        // Given
        let endpoint = TVMazeEndpoint.shows
        let embedding = "cast"
        let request = TVMazeRequest(
            endpoint: endpoint,
            pathComponents: nil,
            queryItems: [
                .init(name: "embed", value: embedding)
            ]
        )

        // When
        let url = request.url

        // Then
        XCTAssertEqual(url?.absoluteString, "https://api.tvmaze.com/shows?embed=\(embedding)")
    }

    func testTVMazeRequestShouldProduceValidFirstShowURL() {
        // Given
        let endpoint = TVMazeEndpoint.shows
        let firstShowID = 1
        let request = TVMazeRequest(
            endpoint: endpoint,
            pathComponents: [String(firstShowID)],
            queryItems: nil
        )

        // When
        let url = request.url

        // Then
        XCTAssertEqual(url?.absoluteString, "https://api.tvmaze.com/shows/1")
    }

    func testTVMazeRequestShouldProduceValidFirstShowWithEmbeddingEpisodesURL() {
        // Given
        let endpoint = TVMazeEndpoint.shows
        let firstShowID = 1
        let embedding = "episodes"
        let request = TVMazeRequest(
            endpoint: endpoint,
            pathComponents: [String(firstShowID)],
            queryItems: [
                .init(name: "embed", value: embedding)
            ]
        )

        // When
        let url = request.url

        // Then
        XCTAssertEqual(url?.absoluteString, "https://api.tvmaze.com/shows/1?embed=\(embedding)")
    }

    func testTVMazeRequestShouldProduceValidEpisodesURL() {
        // Given
        let endpoint = TVMazeEndpoint.episodes
        let request = TVMazeRequest(endpoint: endpoint, pathComponents: nil, queryItems: nil)

        // When
        let url = request.url

        // Then
        XCTAssertEqual(url?.absoluteString, "https://api.tvmaze.com/episodes")
    }

    func testTVMazeRequestShouldProduceValidPeopleURL() {
        // Given
        let endpoint = TVMazeEndpoint.people
        let request = TVMazeRequest(endpoint: endpoint, pathComponents: nil, queryItems: nil)

        // When
        let url = request.url

        // Then
        XCTAssertEqual(url?.absoluteString, "https://api.tvmaze.com/people")
    }
}
