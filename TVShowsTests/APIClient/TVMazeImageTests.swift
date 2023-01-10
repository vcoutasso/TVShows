import XCTest

@testable import TVShows

final class TVMazeImageTests: XCTestCase {
    private let testBundle = Bundle(for: TVMazeImageTests.self)

    func testTVMazeImageShouldDecodeFromJSON() throws {
        let jsonUrl = try XCTUnwrap(testBundle.url(forResource: "UnderTheDomeImage", withExtension: "json"))
        let jsonData = try XCTUnwrap(Data(contentsOf: jsonUrl))

        // When
        let image = try? JSONDecoder().decode(TVMazeImage.self, from: jsonData)

        // Then
        XCTAssertNotNil(image)
    }
}
