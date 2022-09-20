//
//  DescribedError.swift
//  MobileStorage
//
//  Created by Slik on 20.09.2022.
//

protocol DescribedError : Error {
    var title: String { get }
    var description: String { get }
}

extension DescribedError {
    var title: String {
        return "Error"
    }
}
