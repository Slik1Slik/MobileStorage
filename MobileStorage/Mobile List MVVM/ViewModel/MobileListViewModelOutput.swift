//
//  MobileListViewModelOutput.swift
//  MobileStorage
//
//  Created by Slik on 26.09.2022.
//

protocol MobileListViewModelOutput {
    
    var representedData: [Mobile] { get }
    var onDataUpdated: () -> () { get set }
    var onError: (DescribedError) -> () { get set }
}
