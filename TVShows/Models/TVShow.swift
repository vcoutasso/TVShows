import Foundation

struct TVShow: Codable {
    // MARK: Lifecycle

    init(id: Int, name: String, genres: [String], schedule: TVShowSchedule, status: String, premiered: Date? = nil, rating: TVMazeRating? = nil, summary: String? = nil, image: TVMazeImage? = nil) {
        self.id = id
        self.name = name
        self.genres = genres
        self.schedule = schedule
        self.status = status
        self.premiered = premiered
        self.rating = rating
        self.summary = summary
        self.image = image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.genres = try container.decode([String].self, forKey: .genres)
        self.schedule = try container.decode(TVShowSchedule.self, forKey: .schedule)
        self.status = try container.decode(String.self, forKey: .status)
        let premieredDate = try? container.decodeIfPresent(String.self, forKey: .premiered)
        if let premieredDate {
            self.premiered = Date(premieredDate, dateFormat: "yyyy-MM-dd")
        } else {
            self.premiered = nil
        }
        self.rating = try? container.decodeIfPresent(TVMazeRating.self, forKey: .rating)
        self.summary = try container.decodeIfPresent(String.self, forKey: .summary)
        self.image = try container.decodeIfPresent(TVMazeImage.self, forKey: .image)
    }
    
    // MARK: Internal

    let id: Int
    let name: String
    let genres: [String]
    let schedule: TVShowSchedule
    let status: String
    let premiered: Date?
    let rating: TVMazeRating?
    let summary: String?
    let image: TVMazeImage?
}
