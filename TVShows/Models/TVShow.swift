import Foundation

struct TVShow: Codable {
    // MARK: Internal

    let id: Int
    let name: String
    let genres: [String]
    let schedule: TVShowSchedule
    let summary: String?
    let image: String?

    // MARK: Lifecycle

    init(id: Int, name: String, genres: [String], schedule: TVShowSchedule, summary: String, image: String) {
        self.id = id
        self.name = name
        self.genres = genres
        self.schedule = schedule
        self.summary = summary
        self.image = image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.genres = try container.decode([String].self, forKey: .genres)
        self.schedule = try container.decode(TVShowSchedule.self, forKey: .schedule)
        self.summary = (try? container.decode(String.self, forKey: .summary)) ?? "No summary available"
        let image = try? container.decode(TVMazeImage.self, forKey: .image)
        self.image = image?.medium
    }
}
