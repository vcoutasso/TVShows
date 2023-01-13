import Foundation

// MARK: - FlowRoute

protocol FlowRoute { }

// MARK: - AppFlow

enum AppFlow: FlowRoute {
    case shows(ShowsFlow)
    case people(PeopleFlow)
    case favorites(FavoritesFlow)
}

// MARK: - ShowsFlow

enum ShowsFlow: FlowRoute {
    case list
    case showDetails(TVShow)
    case episodeDetails(TVShowEpisode)
}

// MARK: - PeopleFlow

enum PeopleFlow: FlowRoute {
    case list
    case showDetails
}

// MARK: - FavoritesFlow

enum FavoritesFlow: FlowRoute {
    case list
}
