//
//  MobileListViewModelInput.swift
//  MobileStorage
//
//  Created by Slik on 26.09.2022.
//

import Foundation

protocol MobileListViewModelInput {
    
    func fetch()
    func add()
    func select(atIndex index: Int)
    func remove(atIndex index: Int)
    func search(text: String)
}
