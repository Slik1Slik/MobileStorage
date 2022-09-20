//
//  Error.swift
//  MobileStorage
//
//  Created by Slik on 20.09.2022.
//

enum CoreDataError : DescribedError {
    
    case notFound
    case failedToSaveObject
    case failedToAddObject
    case failedToDeleteObject
    
    var description: String {
        switch self {
        case .notFound:
            return "Objects not found"
        case .failedToSaveObject:
            return "Failed to save object"
        case .failedToAddObject:
            return "Failed to add object"
        case .failedToDeleteObject:
            return "Failed to delete object"
        }
    }
}
