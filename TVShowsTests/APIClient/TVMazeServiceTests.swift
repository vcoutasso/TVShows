import XCTest

@testable import TVShows

final class TVMazeServiceTests: XCTestCase {
    private let testBundle = Bundle(for: TVMazeImageTests.self)

    private let jsonDecoderStub = JSONDecoderStub<Int>()
    private let urlSessionStub = NetworkURLSessionStub()
    private lazy var networkSessionSpy = NetworkSessionSpy(urlSession: urlSessionStub)
    private lazy var sut = TVMazeService(jsonDecoder: jsonDecoderStub, networkService: networkSessionSpy)

    func testExecuteShouldFailWithURLSessionError() async {
        // Given
        let expectedError = Fixtures.EquatableError.error
        let dummyRequest = TVMazeRequest(endpoint: .shows, pathComponents: nil, queryItems: nil)
        urlSessionStub.resultError = expectedError

        // When
        let result = await sut.execute(dummyRequest, expecting: Int.self)

        // Then
        guard case .failure(let error) = result,
              let actualError = error as? Fixtures.EquatableError
        else {
            return XCTFail("Expected failure but got success or unexpected error")
        }

        XCTAssertEqual(actualError, expectedError)
    }

    func testExecuteShouldSucceedWithDecodedURLSessionData() async throws {
        // Given
        let dummyRequest = TVMazeRequest(endpoint: .shows, pathComponents: nil, queryItems: nil)
        let expectedData = 42
        jsonDecoderStub.decodedDataStub = expectedData
        urlSessionStub.resultData = Data()
        urlSessionStub.resultResponse = Fixtures.mockURLResponse

        // When
        let result = await sut.execute(dummyRequest, expecting: Int.self)
        let resultData = try XCTUnwrap(result.get())

        // Then
        XCTAssertEqual(resultData, expectedData)
    }

    func testExecuteShouldHandleAPIRateLimitErrors() async {
        // Given
        let dummyRequest = TVMazeRequest(endpoint: .shows, pathComponents: nil, queryItems: nil)
        let expectedError = TVMazeService.TVMazeServiceError.exceededAPIRateLimit
        urlSessionStub.resultData = Data()
        urlSessionStub.resultResponse = Fixtures.mockHTTPURLResponse(statusCode: 429)

        // When
        let result = await sut.execute(dummyRequest, expecting: Int.self)

        // Then
        guard case .failure(let error) = result,
              let actualError = error as? TVMazeService.TVMazeServiceError
        else {
            return XCTFail("Expected failure but got success or unexpected error")
        }

        XCTAssertEqual(actualError, expectedError)
    }
}
