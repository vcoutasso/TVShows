import Foundation

/// Supported TV Maze API path components
enum TVMazePathComponents: CustomStringConvertible {
    case id(Int)
    case episodes

    var description: String {
        switch self {
            case .id(let id):
                return "\(id)"
            case .episodes:
                return "episodes"
        }
    }
}
