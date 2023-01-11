import XCTest

@testable import TVShows

final class TVMazeRequestTests: XCTestCase {
    private let testBundle = Bundle(for: TVMazeRequestTests.self)

    func testURLRequestShouldReturnValidRequest() {
        // Given
        let endpoint = TVMazeEndpoint.shows
        let request = TVMazeRequest(endpoint: endpoint, pathComponents: nil, queryItems: nil)

        // When
        let urlRequest = request.urlRequest()

        // Then
        XCTAssertNotNil(urlRequest)
    }

    func testURLShouldYieldValidShowsURL() {
        // Given
        let endpoint = TVMazeEndpoint.shows
        let request = TVMazeRequest(endpoint: endpoint, pathComponents: nil, queryItems: nil)

        // When
        let url = request.url

        // Then
        XCTAssertEqual(url?.absoluteString, "https://api.tvmaze.com/shows")
    }

    func testURLShouldYieldValidPagingURL() {
        // Given
        let endpoint = TVMazeEndpoint.shows
        let pageNumber = 1
        let request = TVMazeRequest(
            endpoint: endpoint,
            pathComponents: nil,
            queryItems: [
                .page(pageNumber)
            ]
        )

        // When
        let url = request.url

        // Then
        XCTAssertEqual(url?.absoluteString, "https://api.tvmaze.com/shows?page=\(pageNumber)")
    }

    func testURLShouldYieldValidFirstShowURL() {
        // Given
        let endpoint = TVMazeEndpoint.shows
        let firstShowID = 1
        let request = TVMazeRequest(
            endpoint: endpoint,
            pathComponents: [.id(firstShowID)],
            queryItems: nil
        )

        // When
        let url = request.url

        // Then
        XCTAssertEqual(url?.absoluteString, "https://api.tvmaze.com/shows/\(firstShowID)")
    }

    func testURLShouldYieldValidFirstShowEpisodesURL() {
        // Given
        let endpoint = TVMazeEndpoint.shows
        let firstShowID = 1
        let request = TVMazeRequest(
            endpoint: endpoint,
            pathComponents: [
                .id(firstShowID),
                .episodes
            ],
            queryItems: nil
        )

        // When
        let url = request.url

        // Then
        XCTAssertEqual(url?.absoluteString, "https://api.tvmaze.com/shows/1/episodes")
    }

    func testURLShouldYieldValidEpisodesURL() {
        // Given
        let endpoint = TVMazeEndpoint.episodes
        let request = TVMazeRequest(endpoint: endpoint, pathComponents: nil, queryItems: nil)

        // When
        let url = request.url

        // Then
        XCTAssertEqual(url?.absoluteString, "https://api.tvmaze.com/episodes")
    }

    func testURLShouldYieldValidPeopleURL() {
        // Given
        let endpoint = TVMazeEndpoint.people
        let request = TVMazeRequest(endpoint: endpoint, pathComponents: nil, queryItems: nil)

        // When
        let url = request.url

        // Then
        XCTAssertEqual(url?.absoluteString, "https://api.tvmaze.com/people")
    }
}
