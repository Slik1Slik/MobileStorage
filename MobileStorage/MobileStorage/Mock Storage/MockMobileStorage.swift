//
//  MockMobileStorage.swift
//  MobileStorage
//
//  Created by Slik on 21.09.2022.
//

import Foundation

class MockMobileStorage : MobileStorage {
    func getAll() -> Set<Mobile> {
        NSOrderedSet(array: mocks).set as? Set<Mobile> ?? []
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        mocks.first { $0.imei == imei }
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        mocks.append(mobile)
        return mobile
    }
    
    func delete(_ product: Mobile) throws {
        mocks.removeAll { $0.imei == product.imei }
    }
    
    func exists(_ product: Mobile) -> Bool {
        mocks.contains(product)
    }
    
    private var mocks: [Mobile] = [
        Mobile(imei: UUID().uuidString, model: "iPhone X"),
        Mobile(imei: UUID().uuidString, model: "iPhone 11"),
        Mobile(imei: UUID().uuidString, model: "iPhone 12"),
        Mobile(imei: UUID().uuidString, model: "iPhone 13"),
    ]
}
