import Foundation

protocol ImageLoading: AnyObject {
    init(networkService: NetworkRequesting)

    static var shared: Self { get }

    func fetchImageData(for url: URL) async -> Result<Data, Error>
}

final class CachedImageLoader: ImageLoading {
    // MARK: Lifecycle

    init(networkService: NetworkRequesting) {
        self.networkService = networkService
    }

    static let shared: CachedImageLoader = .init(networkService: NetworkSession.default)

    // MARK: Internal

    func fetchImageData(for url: URL) async -> Result<Data, Error> {
        let key = url.absoluteString as NSString

        if let data = cache.object(forKey: key) {
            return .success(data as Data)
        }

        do {
            let (data, _) = try await networkService.execute(for: URLRequest(url: url))
            cache.setObject(data as NSData, forKey: key)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }

    // MARK: Private

    private let cache = NSCache<NSString, NSData>()
    private let networkService: NetworkRequesting
}
