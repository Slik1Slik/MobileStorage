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
                       predicate: NSPredicate? = nil,
                       completion: @escaping (Result<[T], CoreDataError>) -> ())
    {
        
        guard let name = T.entity().name else {
            completion(.failure(.notFound))
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        if let objects = try? context.fetch(fetchRequest) as? [T] {
            completion(.success(objects))
            return
        }
        
        completion(.failure(.notFound))
    }
    
    static func delete(context: NSManagedObjectContext,
                       sortDescriptors: [NSSortDescriptor]? = nil,
                       predicate: NSPredicate? = nil,
                       completion: @escaping (Result<[T], CoreDataError>) -> ())
    {
        var objects: [T] = []
        
        getAll(context: context,
               sortDescriptors: sortDescriptors,
               predicate: predicate) { result in
            switch result {
            case .success(let foundObjects):
                objects = foundObjects
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        objects.forEach { context.delete($0) }
    }
    
    static func update(context: NSManagedObjectContext,
                       propertiesToUpdate: [AnyHashable: Any],
                       completion: @escaping (Result<Void, CoreDataError>) -> ())
    {
        do {
            try update(context: context,
                       propertiesToUpdate: propertiesToUpdate)
        } catch {
            completion(.failure(.failedToSaveObject))
        }
    }
    
    static func add(context: NSManagedObjectContext,
                    propertiesToUpdate: [AnyHashable: Any],
                    completion: @escaping (Result<Void, CoreDataError>) -> ())
    {
        do {
            try update(context: context,
                       propertiesToUpdate: propertiesToUpdate)
        } catch {
            completion(.failure(.failedToAddObject))
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
