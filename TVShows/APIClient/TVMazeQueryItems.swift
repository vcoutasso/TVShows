import Foundation

/// Supported TV Maze API query items
enum TVMazeQueryItems {
    case page(Int)
    case query(String)

    func urlQueryItem() -> URLQueryItem {
        switch self {
            case .page(let value):
                let name = String(describing: self).alphabeticalOnly()
                return .init(name: name, value: String(value))
            case .query(let query):
                return .init(name: "q", value: query)
        }
    }
}
