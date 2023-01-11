import Foundation
import XCTest

@testable import TVShows

final class ImageLoadingStub: ImageLoading {
    // MARK: Lifecycle
    init() {}
    init(networkService: NetworkRequesting) {}

    var dataStub: Data?
    var errorStub: Error = Fixtures.mockNSError

    var expectation: XCTestExpectation?

    static var shared: ImageLoadingStub = .init()

    private(set) var didFetchImageData = false
    func fetchImageData(for url: URL) async -> Result<Data, Error> {
        didFetchImageData = true
        expectation?.fulfill()
        guard let dataStub else {
            return .failure(errorStub)
        }

        return .success(dataStub)
    }
}
