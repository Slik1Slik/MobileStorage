//
//  Mobile+CoreDataProperties.swift
//  MobileStorage
//
//  Created by Slik on 20.09.2022.
//
//

import Foundation
import CoreData


extension MobileObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MobileObject> {
        return NSFetchRequest<MobileObject>(entityName: "Mobile")
    }

    @NSManaged public var imei: String?
    @NSManaged public var model: String?

}

extension MobileObject : Identifiable {

}
