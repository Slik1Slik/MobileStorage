//
//  ViewModelListener.swift
//  MobileStorage
//
//  Created by Slik on 26.09.2022.
//

import Foundation

protocol ViewModelListener {
    
    associatedtype ViewModel
    
    func set(_ viewModel: ViewModel)
    
    func listenViewModel()
}
