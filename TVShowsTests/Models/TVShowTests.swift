import XCTest

@testable import TVShows

final class TVShowTests: XCTestCase {
    private let testBundle = Bundle(for: TVShowTests.self)

    func testShouldDecodeFromJSON() throws {
        // Given
        let jsonUrl = try XCTUnwrap(testBundle.url(forResource: "UnderTheDome", withExtension: ".json"))
        let jsonData = try XCTUnwrap(Data(contentsOf: jsonUrl))

        // When
        let show = try? JSONDecoder().decode(TVShow.self, from: jsonData)

        // Then
        XCTAssertNotNil(show)
    }
}
