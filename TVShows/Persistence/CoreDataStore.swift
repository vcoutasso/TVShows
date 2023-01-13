import Foundation
import CoreData

// MARK: - CoreDataStore

final class CoreDataStore: DataPersisting {
    // MARK: Lifecycle

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    deinit {
        try? context.save()
    }

    // MARK: Internal

    static let shared: CoreDataStore = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return .init(context: container.viewContext)
    }()

    func isShowInFavorites(id: Int) -> Bool {
        getFavoriteShow(for: id) != nil
    }

    func addToFavorites(_ show: TVShow) -> Result<Void, Error> {
        let newFavorite = FavoriteShow(context: context)
        newFavorite.id = Int64(show.id)
        newFavorite.name = show.name
        newFavorite.genres = show.genres
        newFavorite.status = show.status
        newFavorite.premiered = show.premiered
        newFavorite.summary = show.summary

        let schedule = FavoriteShowSchedule(context: context)
        schedule.time = show.schedule.time
        schedule.days = show.schedule.days
        newFavorite.schedule = schedule

        if let showRating = show.rating {
            let rating = FavoriteShowRating(context: context)
            rating.average = showRating.average
            newFavorite.rating = rating
        }

        if let showImage = show.image {
            let images = FavoriteShowImages(context: context)
            images.medium = showImage.medium
            images.original = showImage.original
            newFavorite.image = images
        }

        return saveContext()
    }

    func removeFromFavorites(id: Int) -> Result<Void, Error> {
        if let favoriteShow = getFavoriteShow(for: id) {
            context.delete(favoriteShow)
        }

        return saveContext()
    }

    // MARK: Private

    private let context: NSManagedObjectContext

    private func getFavoriteShow(for id: Int) -> FavoriteShow? {
        do {
            let request = FavoriteShow.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)

            return try context.fetch(request).first
        } catch {
            print(error)
            return nil
        }
    }

    private func saveContext() -> Result<Void, Error> {
        do {
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
