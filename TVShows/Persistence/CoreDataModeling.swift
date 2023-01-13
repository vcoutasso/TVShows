import Foundation
import CoreData

extension FavoriteShow {
    @discardableResult static func fromDomain(_ show: TVShow, in context: NSManagedObjectContext) -> FavoriteShow {
        let newFavorite = FavoriteShow(context: context)
        newFavorite.id = Int64(show.id)
        newFavorite.name = show.name
        newFavorite.genres = show.genres
        newFavorite.status = show.status
        newFavorite.premiered = show.premiered
        newFavorite.summary = show.summary

        let schedule = FavoriteShowSchedule.fromDomain(show.schedule, in: context)
        newFavorite.schedule = schedule

        if let showRating = show.rating {
            let rating = FavoriteShowRating.fromDomain(showRating, in: context)
            newFavorite.rating = rating
        }

        if let showImage = show.image {
            let image = FavoriteShowImages.fromDomain(showImage, in: context)
            newFavorite.image = image
        }

        return newFavorite
    }

    func toDomain() -> TVShow? {
        guard let name, let genres, let status else { return nil }
        return .init(
            id: Int(id),
            name: name,
            genres: genres,
            schedule: schedule?.toDomain() ?? .init(time: "", days: []),
            status: status,
            premiered: premiered,
            rating: rating?.toDomain(),
            summary: summary,
            image: image?.toDomain()
        )
    }
}

extension FavoriteShowSchedule {
    static func fromDomain(_ schedule: TVShowSchedule, in context: NSManagedObjectContext) -> FavoriteShowSchedule {
        let newSchedule = FavoriteShowSchedule(context: context)
        newSchedule.time = schedule.time
        newSchedule.days = schedule.days

        return newSchedule
    }

    func toDomain() -> TVShowSchedule? {
        guard let time, let days else { return nil }
        return .init(time: time, days: days)
    }
}

extension FavoriteShowRating {
    static func fromDomain(_ rating: TVMazeRating, in context: NSManagedObjectContext) -> FavoriteShowRating {
        let newRating = FavoriteShowRating(context: context)
        newRating.average = rating.average

        return newRating
    }

    func toDomain() -> TVMazeRating? {
        .init(average: average)
    }
}

extension FavoriteShowImages {
    static func fromDomain(_ image: TVMazeImage, in context: NSManagedObjectContext) -> FavoriteShowImages {
        let newImage = FavoriteShowImages(context: context)
        newImage.medium = image.medium
        newImage.original = image.original

        return newImage
    }

    func toDomain() -> TVMazeImage? {
        guard let medium, let original else { return nil }
        return .init(medium: medium, original: original)
    }
}
