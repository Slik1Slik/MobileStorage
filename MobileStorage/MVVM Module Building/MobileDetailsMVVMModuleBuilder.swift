//
//  MobileDetailsMVVMModuleBuilder.swift
//  MobileStorage
//
//  Created by Slik on 27.09.2022.
//

import UIKit

final class MobileDetailsMVVMModuleBuilder : MVVMModuleBuilder {
    
    private var storageType: MobileStorageType
    private var mode: MobileDetailsViewModel.Mode
    
    func build() -> UIViewController {
        let vc = MobileDetailsViewController()
        vc.imeiTextField.isEnabled = mode == .add
        vc.set(viewModel())
        vc.listenViewModel()
        return vc
    }
    
    init(_ mobileStorageType: MobileStorageType, mode: MobileDetailsViewModel.Mode) {
        self.storageType = mobileStorageType
        self.mode = mode
    }
    
    private func viewModel() -> MobileDetailsViewModel {
        let viewModel = MobileDetailsViewModel()
        viewModel.configure(mobileStorage: storageType.storage,
                            mode: mode)
        return viewModel
    }
}
