import Foundation

struct TVShowEpisode: Codable {
    let id: Int
    let name: String
    let season: Int
    let number: Int
    let summary: String
    let image: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.season = try container.decode(Int.self, forKey: .season)
        self.number = try container.decode(Int.self, forKey: .number)
        self.summary = try container.decode(String.self, forKey: .summary)
        let image = try container.decode(TVMazeImage.self, forKey: .image)
        self.image = image.medium
    }
}
