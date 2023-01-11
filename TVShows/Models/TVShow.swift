import Foundation

struct TVShow: Codable {
    // MARK: Internal

    let id: Int
    let name: String
    let genres: [String]
    let schedule: TVShowSchedule
    let summary: String?
    let image: TVMazeImage?
}
