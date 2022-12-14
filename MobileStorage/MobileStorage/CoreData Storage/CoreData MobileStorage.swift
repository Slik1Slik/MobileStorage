//
//  CoreData MobileStorage.swift
//  MobileStorage
//
//  Created by Slik on 21.09.2022.
//

import CoreData
import UIKit

final class CoreDataMobileStorage : MobileStorage {
    
    private var contextHolder: CoreDataContextHolder?
    
    init() {
        self.contextHolder = (UIApplication.shared.delegate as? AppDelegate)?.mobileContextHolder
    }
    
    func getAll() -> Set<Mobile> {
        
        guard let context = contextHolder?.managedObjectContext else {
            return []
        }
        let sortDescriptor = NSSortDescriptor(key: "model", ascending: true)
        let mobileArray = CoreDataStorageManager<MobileObject>.getAll(context: context,
                                                                      sortDescriptors: [sortDescriptor])
        
        return (NSOrderedSet(array: mobileArray.map { $0.toMobile }).set as? Set<Mobile>) ?? []
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        
        guard let context = contextHolder?.managedObjectContext else {
            return nil
        }
        
        let predicate = predicate(forEMIE: imei, with: .fuzzyMatch)
        let result = CoreDataStorageManager<MobileObject>.getAll(context: context,
                                                                 predicate: predicate)
        guard let object = result.first else {
            return nil
        }
        return Mobile(imei: object.imei,
                      model: object.model)
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        
        guard let context = contextHolder?.managedObjectContext else {
            throw CoreDataError.failedToSaveObject
        }
        
        let properties = propertiesToUpdate(from: mobile)
        
        if !exists(mobile) {
            try CoreDataStorageManager<MobileObject>.add(context: context,
                                                         properties: properties)
        } else {
            let predicate = predicate(forEMIE: mobile.imei, with: .fullMatch)
            try CoreDataStorageManager<MobileObject>.update(context: context,
                                                            predicate: predicate,
                                                            propertiesToUpdate: properties)
        }
        
        try contextHolder?.saveContext()
        
        return mobile
    }
    
    func delete(_ product: Mobile) throws {
        
        guard let context = contextHolder?.managedObjectContext else {
            throw CoreDataError.failedToDeleteObject
        }
        
        let predicate = predicate(forEMIE: product.imei, with: .fullMatch)
        try CoreDataStorageManager<MobileObject>.delete(context: context,
                                                        predicate: predicate)
        try contextHolder?.saveContext()
    }
    
    func exists(_ product: Mobile) -> Bool {
        
        guard let context = contextHolder?.managedObjectContext else {
            return false
        }
        
        let predicate = predicate(forEMIE: product.imei, with: .fullMatch)
        
        return !CoreDataStorageManager<MobileObject>.getAll(context: context,
                                                            predicate: predicate).isEmpty
    }
}
//MARK: - Predicate
extension CoreDataMobileStorage {
    
    private func predicate(forEMIE emei: String,
                           with option: PredicateOption) -> NSPredicate {
        
        let predicateFormat = "imei \(option.rawValue) %@"
        return NSPredicate(format: predicateFormat, emei)
    }
    
    private enum PredicateOption: String {
        case fullMatch = "="
        case fuzzyMatch = "CONTAINS[c]"
    }
}
//MARK: - Properties to update
extension CoreDataMobileStorage {
    
    private func propertiesToUpdate(from mobile: Mobile) -> [String : Any] {
        
        return ["model" : mobile.model, "imei" : mobile.imei]
    }
}
