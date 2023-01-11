import Foundation

enum TVMazeFuzzySearchResults {
    struct Shows: Codable {
        let score: Double
        let show: TVShow
    }
}
