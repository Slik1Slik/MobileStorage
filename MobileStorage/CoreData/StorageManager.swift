//
//  StorageManager.swift
//  MobileStorage
//
//  Created by Slik on 20.09.2022.
//

import CoreData

final class CoreDataStorageManager<T : NSManagedObject> {

    static func getAll(context: NSManagedObjectContext,
                        sortDescriptors: [NSSortDescriptor]? = nil,
                        predicate: NSPredicate? = nil) -> [T]
    {

        guard let name = T.entity().name else {
            return []
        }
    
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate

        return (try? context.fetch(fetchRequest) as? [T]) ?? []
    }

    static func delete(context: NSManagedObjectContext,
                        sortDescriptors: [NSSortDescriptor]? = nil,
                        predicate: NSPredicate? = nil) throws
    {

        getAll(context: context).forEach { context.delete($0) }
    }

    static func add(context: NSManagedObjectContext,
                       propertiesToUpdate: [AnyHashable: Any]) throws
    {
        do {
            try update(context: context,
                        propertiesToUpdate: propertiesToUpdate)
        } catch {
            throw CoreDataError.failedToAddObject
        }
    }

    private static func update(context: NSManagedObjectContext,
                                    propertiesToUpdate: [AnyHashable: Any]) throws
    {

        guard let name = T.entity().name else {
            throw CoreDataError.failedToSaveObject
        }

        let request = NSBatchUpdateRequest(entityName: name)

        request.propertiesToUpdate = propertiesToUpdate
        request.resultType = .updatedObjectsCountResultType

        guard let _ = try? context.execute(request) else {
            throw CoreDataError.failedToSaveObject
        }
    }
}
