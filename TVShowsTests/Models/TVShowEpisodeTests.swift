import XCTest

@testable import TVShows

final class TVShowEpisodeTests: XCTestCase {
    private let testBundle = Bundle(for: TVShowEpisodeTests.self)

    func testTVShowEpisodeShouldDecodeFromJSON() throws {
        // Given
        let jsonUrl = try XCTUnwrap(testBundle.url(forResource: "UnderTheDome-EP1", withExtension: ".json"))
        let jsonData = try XCTUnwrap(Data(contentsOf: jsonUrl))

        // When
        let episode = try? JSONDecoder().decode(TVShowEpisode.self, from: jsonData)

        // Then
        XCTAssertNotNil(episode)
    }
}
