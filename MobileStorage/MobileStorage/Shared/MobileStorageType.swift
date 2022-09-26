//
//  MobileStorageType.swift
//  MobileStorage
//
//  Created by Slik on 21.09.2022.
//

enum MobileStorageType {
    case mock
    case coreData
    
    var storage: MobileStorage {
        switch self {
        case .mock:
            return MockMobileStorage()
        case .coreData:
            return CoreDataMobileStorage()
        }
    }
}
