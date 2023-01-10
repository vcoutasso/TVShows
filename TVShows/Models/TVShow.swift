import Foundation

struct TVShow: Codable {
    // MARK: Internal

    let id: Int
    let name: String
    let genres: [String]
    let schedule: TVShowSchedule
    let summary: String
    let posterURL: String

    // MARK: Lifecycle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.genres = try container.decode([String].self, forKey: .genres)
        self.schedule = try container.decode(TVShowSchedule.self, forKey: .schedule)
        self.summary = try container.decode(String.self, forKey: .summary)
        let image = try container.decode(Image.self, forKey: .posterURL)
        self.posterURL = image.original
    }

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case genres
        case schedule
        case summary
        case posterURL = "image"
    }

    private struct Image: Codable {
        let medium: String
        let original: String
    }
}