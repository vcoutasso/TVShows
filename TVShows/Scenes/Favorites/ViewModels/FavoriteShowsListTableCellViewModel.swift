import Foundation

// MARK: - FavoriteShowsListTableCellViewModelProtocol

@MainActor
protocol FavoriteShowsListTableCellViewModelProtocol {
    var show: TVShow { get }

    func fetchImageData() async -> Data?
}

// MARK: - FavoriteShowsListTableCellViewModel

final class FavoriteShowsListTableCellViewModel: FavoriteShowsListTableCellViewModelProtocol {
    // MARK: Lifecycle

    init(show: TVShow, imageLoader: ImageLoading) {
        self.show = show
        self.imageLoader = imageLoader
    }

    // MARK: Internal

    private(set) var show: TVShow

    func fetchImageData() async -> Data? {
        guard let urlString = show.image?.medium,
              let url = URL(string: urlString)
        else { return nil }

        switch await imageLoader.fetchImageData(for: url) {
            case .success(let data):
                return data
            case .failure:
                return nil
        }
    }

    // MARK: Private

    private let imageLoader: ImageLoading
}
