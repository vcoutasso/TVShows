import Foundation
import XCTest

@testable import TVShows

final class ImageLoaderStub: ImageLoading {
    // MARK: Lifecycle
    init() {}
    init(networkService: NetworkRequesting) {}

    var dataStub: Data?
    var errorStub: Error = Fixtures.mockNSError

    static var shared: ImageLoaderStub = .init()

    private(set) var didFetchImageData = false
    func fetchImageData(for url: URL) async -> Result<Data, Error> {
        didFetchImageData = true
        guard let dataStub else {
            return .failure(errorStub)
        }

        return .success(dataStub)
    }
}
