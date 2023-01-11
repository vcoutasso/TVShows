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
        guard let imageUrl = show.image,
              let url = URL(string: imageUrl) else {
            return print("Failed to generate URL for \(show.image ?? "null image url")")
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
