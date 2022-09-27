//
//  MobileDetailsViewModelInput.swift
//  MobileStorage
//
//  Created by Slik on 26.09.2022.
//

import Foundation

protocol MobileDetailsViewModelOutput {

    var model: String { get set }
    var modelPlaceholder: String { get }
    var modelTitle: String { get }
    var modelFooter: String { get }

    var imei: String { get set }
    var imeiPlaceholder: String { get }
    var imeiTitle: String { get }
    var imeiFooter: String { get }

    var delegate: MobileDetailsViewModelDelegate? { get set }

    var onError: (DescribedError) -> () { get set }
    var onSuccess: () -> () { get set }
}

protocol MobileDetailsViewModelDelegate : AnyObject {
    func viewModel(canSave: Bool)
}
