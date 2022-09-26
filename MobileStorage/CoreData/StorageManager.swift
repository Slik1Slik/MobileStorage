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
        guard let name = T.entity().name else {
            throw CoreDataError.failedToSaveObject
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        guard let _ = try? context.execute(deleteRequest) else {
            throw CoreDataError.failedToDeleteObject
        }
    }
    
    static func add(context: NSManagedObjectContext,
                    properties: [String: Any]) throws
    {
        guard let name = T.entity().name else {
            throw CoreDataError.failedToAddObject
        }
        
        let object = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as? T
        
        properties.forEach { property in
            object?.setValue(property.value, forKey: property.key)
        }
    }
    
    static func update(context: NSManagedObjectContext,
                       predicate: NSPredicate,
                       propertiesToUpdate: [String: Any]) throws
    {
        guard let object = getAll(context: context, predicate: predicate).first else {
            throw CoreDataError.notFound
        }
        
        propertiesToUpdate.forEach { property in
            object.setValue(property.value, forKey: property.key)
        }
    }
}
