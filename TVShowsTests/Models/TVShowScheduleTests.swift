import XCTest

@testable import TVShows

final class TVShowScheduleTests: XCTestCase {
    private let testBundle = Bundle(for: TVShowScheduleTests.self)

    func testTVShowScheduleShouldDecodeFromJSON() throws {
        // Given
        let jsonUrl = try XCTUnwrap(testBundle.url(forResource: "UnderTheDomeSchedule", withExtension: "json"))
        let jsonData = try XCTUnwrap(Data(contentsOf: jsonUrl))

        // When
        let schedule = try? JSONDecoder().decode(TVShowSchedule.self, from: jsonData)

        // Then
        XCTAssertNotNil(schedule)
    }

}
