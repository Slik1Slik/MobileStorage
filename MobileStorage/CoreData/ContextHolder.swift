//
//  ContextHolder.swift
//  MobileStorage
//
//  Created by Slik on 20.09.2022.
//

import CoreData

final class CoreDataContextHolder: NSObject {
    
    static let storageDidChangeNotification: Notification.Name = .init(rawValue: "storageDidChangeNotification")

    private(set) var managedObjectContext: NSManagedObjectContext?
    
    private var model: Model = .mobile

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: model.rawValue)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    init(model: Model) {
        super.init()
        self.model = model
        self.managedObjectContext = persistentContainer.viewContext
    }

    func saveContext() throws {
        
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        if context.hasChanges {
            do {
                try context.save()
                notifyObservers()
            } catch {
                context.rollback()
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                throw CoreDataError.failedToSaveObject
            }
        }
    }
    
    enum Model: String {
        case mobile = "MobileStorage"
    }
}
//MARK: - Notifications
extension CoreDataContextHolder {
    
    private func notifyObservers() {
        NotificationCenter.default.post(name: Self.storageDidChangeNotification, object: nil)
    }
}
