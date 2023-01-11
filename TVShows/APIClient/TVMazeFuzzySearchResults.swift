import Foundation

/// Supported types of results from the fuzzy search TV Maze API
enum TVMazeFuzzySearchResults {
    struct Shows: Codable {
        let score: Double
        let show: TVShow
    }
}
