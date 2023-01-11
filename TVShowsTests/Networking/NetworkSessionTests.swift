import XCTest

@testable import TVShows

final class NetworkSessionTests: XCTestCase {
    private let urlSessionStub = NetworkURLSessionStub()
    private lazy var sut = NetworkSession(urlSession: urlSessionStub)

    private let testBundle = Bundle(for: NetworkSessionTests.self)

    func testExecuteShouldYieldResultsFromURLSession() async throws {
        // Given
        let resourceURL = try XCTUnwrap(testBundle.url(forResource: "UnderTheDome", withExtension: "json"))
        urlSessionStub.resultData = try Data(contentsOf: resourceURL)
        urlSessionStub.resultResponse = Fixtures.mockURLResponse

        // When
        let (data, response) = try await sut.execute(for: Fixtures.mockURLRequest)

        // Then
        XCTAssertEqual(data, urlSessionStub.resultData)
        XCTAssertEqual(response, urlSessionStub.resultResponse)
    }

    func testExecuteShouldThrowErrorsFromURLSession() async {
        // Given
        let expectedError = urlSessionStub.resultError as NSError

        // When / Then
        do {
            let _ = try await sut.execute(for: Fixtures.mockURLRequest)
            XCTFail("The above call is expected to throw an error.")
        } catch {

            XCTAssertIdentical(error as NSError, expectedError)
        }

    }
}
