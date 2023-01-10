import XCTest

@testable import TVShows

final class CachedImageLoaderTests: XCTestCase {
    private let urlSessionStub = NetworkURLSessionStub()
    private lazy var networkServiceSpy = NetworkSessionSpy(urlSession: urlSessionStub)
    private lazy var sut = CachedImageLoader(networkService: networkServiceSpy)

    func testCachedImageLoaderShouldRetrieveDataFromNetworkService() async throws {
        // Given
        var meaningOfLife = 42
        let dummyData = Data(bytes: &meaningOfLife, count: MemoryLayout.size(ofValue: meaningOfLife))
        urlSessionStub.resultData = dummyData
        urlSessionStub.resultResponse = Fixtures.mockURLResponse

        // When
        let result = await sut.fetchImageData(for: Fixtures.mockURL)
        let data = try XCTUnwrap(result.get())

        // Then
        XCTAssertTrue(networkServiceSpy.didExecuteService)
        XCTAssertEqual(data, dummyData)
    }

    func testCachedImageLoaderShouldRetrieveDataFromCache() async throws {
        // Given
        var meaningOfLife = 42
        let dummyData = Data(bytes: &meaningOfLife, count: MemoryLayout.size(ofValue: meaningOfLife))
        urlSessionStub.resultData = dummyData
        urlSessionStub.resultResponse = Fixtures.mockURLResponse

        // When
        // Set cache
        let _ = await sut.fetchImageData(for: Fixtures.mockURL)
        // Reset stub
        urlSessionStub.resultData = nil
        urlSessionStub.resultResponse = nil
        // Try to retrieve from cache
        let result = await sut.fetchImageData(for: Fixtures.mockURL)
        let data = try XCTUnwrap(result.get())

        // Then
        XCTAssertTrue(networkServiceSpy.didExecuteService)
        XCTAssertEqual(data, dummyData)
    }

    func testCachedImageLoaderShouldFailWithURLSessionError() async {
        // Given
        let expectedError = Fixtures.EquatableError.error
        urlSessionStub.resultError = expectedError

        // When
        let result = await sut.fetchImageData(for: Fixtures.mockURL)

        // Then
        guard case .failure(let error) = result,
              let actualError = error as? Fixtures.EquatableError
        else {
            return XCTFail("Expected failure but got success or unexpected error")
        }

        XCTAssertEqual(actualError, expectedError)
    }
}
