import Foundation

/// Supported TV Maze API query items
enum TVMazeQueryItems {
    case page(Int)

    func urlQueryItem() -> URLQueryItem {
        switch self {
            case .page(let value):
                let name = String(describing: self).alphabeticalOnly()
                return .init(name: name, value: String(value))
        }
    }
}
