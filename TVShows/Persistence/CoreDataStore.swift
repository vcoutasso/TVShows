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

    func getFavoriteShows() -> [TVShow] {
        do {
            let request = FavoriteShow.fetchRequest()

            return try context.fetch(request).compactMap { $0.toDomain() }
        } catch {
            print(error)
            return []
        }
    }

    func addToFavorites(_ show: TVShow) -> Result<Void, Error> {
        FavoriteShow.fromDomain(show, in: context)
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
