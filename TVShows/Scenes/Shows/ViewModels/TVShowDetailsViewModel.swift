import Foundation

@MainActor
protocol TVShowDetailsViewModelProtocol: AnyObject {
    var show: TVShow { get }
}
final class TVShowDetailsViewModel: TVShowDetailsViewModelProtocol {
    // MARK: Lifecycle

    init(show: TVShow) {
        self.show = show
    }

    // MARK: Internal

    let show: TVShow
}
