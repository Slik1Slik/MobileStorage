//
//  AnyError.swift
//  MobileStorage
//
//  Created by Slik on 20.09.2022.
//

final class AnyError : DescribedError {
    
    var description: String {
        return _description
    }
    
    private let _description: String
    
    init(description: String = "") {
        self._description = description
    }
}
