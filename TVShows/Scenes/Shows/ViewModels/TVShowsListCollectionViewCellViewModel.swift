import Foundation

// MARK: - TVShowsListCollectionViewCellViewModelProtocol

protocol TVShowsListCollectionViewCellViewModelProtocol: AnyActor {
    nonisolated var show: TVShow { get }

    init(show: TVShow, imageLoader: ImageLoading)

    func fetchImageData() async -> Data?
    func getImageData() async -> Data?
}

// MARK: - TVShowsListCollectionViewCellViewModel

actor TVShowsListCollectionViewCellViewModel: TVShowsListCollectionViewCellViewModelProtocol {
    // MARK: Lifecycle

    init(show: TVShow, imageLoader: ImageLoading = CachedImageLoader.shared) {
        self.show = show
        self.imageLoader = imageLoader
    }

    // MARK: Internal

    let show: TVShow

    func fetchImageData() async -> Data? {
        // No image to be fetched
        guard let imageUrl = show.image?.medium else { return nil }
        guard let url = URL(string: imageUrl) else {
            print("Failed to generate URL for \(imageUrl)")
            return nil
        }

        switch await imageLoader.fetchImageData(for: url) {
            case .success(let data):
                imageData = data
            case .failure(let error):
                print("Failed to fetch image for \(url.absoluteString) with \(error)")
        }

        return imageData
    }

    func getImageData() async -> Data? {
        imageData
    }

    // MARK: Private

    private let imageLoader: ImageLoading
    private var imageData: Data?
}
