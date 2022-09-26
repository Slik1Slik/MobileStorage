//
//  MobileListMVVMModuleBuilder.swift
//  MobileStorage
//
//  Created by Slik on 21.09.2022.
//

import UIKit

class MobileListMVVMModuleBuilder : MVVMModuleBuilder {
    
    private var viewModel: MobileListViewModel = MobileListViewModel()
    
    init(_ mobileStorage: MobileStorageType = .coreData) {
        
        viewModel.setStorage(mobileStorage.storage)
    }
    
    func build() -> UIViewController {
        let vc = MobileListViewController()
        vc.set(viewModel)
        vc.listenViewModel()
        return vc
    }
    
}
