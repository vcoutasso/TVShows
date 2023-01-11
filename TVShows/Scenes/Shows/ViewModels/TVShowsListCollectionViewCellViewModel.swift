import Foundation

protocol TVShowsListCollectionViewCellViewModelProtocol {
    var show: TVShow { get }
    var imageData: Data? { get }

    init(show: TVShow, imageLoader: ImageLoading)

    func fetchImage() async
}

final class TVShowsListCollectionViewCellViewModel: TVShowsListCollectionViewCellViewModelProtocol {
    // MARK: Lifecycle

    init(show: TVShow, imageLoader: ImageLoading = CachedImageLoader.shared) {
        self.show = show
        self.imageLoader = imageLoader
    }

    // MARK: Internal

    func fetchImage() async {
        // No image to be fetched
        guard let imageUrl = show.image else { return }
        guard let url = URL(string: imageUrl) else {
            return print("Failed to generate URL for \(imageUrl)")
        }

        switch await imageLoader.fetchImageData(for: url) {
            case .success(let data):
                imageData = data
            case .failure(let error):
                print("Failed to fetch image for \(url.absoluteString) with \(error)")
        }
    }

    private(set) var show: TVShow
    private(set) var imageData: Data?

    // MARK: Private

    private let imageLoader: ImageLoading
}
