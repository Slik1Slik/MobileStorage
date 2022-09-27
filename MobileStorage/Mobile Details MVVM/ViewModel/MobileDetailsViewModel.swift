//
//  MobileDetailsViewModel.swift
//  MobileStorage
//
//  Created by Slik on 26.09.2022.
//

import Foundation
import UIKit

protocol MobileDetailsViewModelProtocol : MobileDetailsViewModelInput, MobileDetailsViewModelOutput {
    
    associatedtype Mode
    
    func configure(mobileStorage: MobileStorage, mode: Mode)
}

final class MobileDetailsViewModel : MobileDetailsViewModelProtocol {
    
    var model: String = "" {
        didSet {
            validate()
        }
    }
    var modelPlaceholder: String = "iPhone 14"
    var modelTitle: String = "Model"
    var modelFooter: String = "The name of the model, must contain more than 3 symbols."
    
    var imei: String = "" {
        didSet {
            validate()
        }
    }
    var imeiPlaceholder: String = "911761395051803"
    var imeiTitle: String = "IMEI"
    var imeiFooter: String = "Is a unique number to identify mobile phones, as well as some satellite phones. Contains 15-17 characters (numbers only)."
    
    var onError: (DescribedError) -> () = { _ in }
    var onSuccess: () -> () = { }
    
    private var mobileStorage: MobileStorage = CoreDataMobileStorage()
    
    private var mode: Mode = .add
    
    var delegate: MobileDetailsViewModelDelegate? {
        didSet {
            validate()
        }
    }
    
    private var validator: MobileDetailsValidator = MobileDetailsValidator()
}
//MARK: - Configuration
extension MobileDetailsViewModel {
    
    func configure(mobileStorage: MobileStorage, mode: Mode) {
        
        self.mobileStorage = mobileStorage
        self.mode = mode
        
        switch mode {
        case .add:
            break
        case .update(let imei):
            guard let mobile = mobileStorage.findByImei(imei) else {
                onError(CoreDataError.notFound)
                return
            }
            self.model = mobile.model
            self.imei = mobile.imei
        }
    }
}
//MARK: - Validation
extension MobileDetailsViewModel {
    
    private func validate() {
        delegate?.viewModel(canSave: validator.isValid(model: model, imei: imei))
    }
}
//MARK: - MobileDetailsViewModel option
extension MobileDetailsViewModel {
    
    enum Mode : Equatable {
        case add
        case update(String)
    }
}
//MARK: - Mobile storage
extension MobileDetailsViewModel {
    
    func save() {
        switch mode {
        case .add:
            add()
        case .update(let imei):
            update(oldIEMI: imei)
        }
    }
    
    private func add() {
        let mobile = Mobile(imei: imei, model: model)
        guard !mobileStorage.exists(mobile) else {
            onError(AnyError(description: "\(CoreDataError.failedToSaveObject.description): Mobile already exists"))
            return
        }
        do {
            let _ = try mobileStorage.save(mobile)
            onSuccess()
        } catch let error as DescribedError {
            onError(error)
        } catch {
            return
        }
    }
    
    private func update(oldIEMI: String) {
        let mobile = Mobile(imei: imei, model: model)
        guard oldIEMI != imei else {
            if mobileStorage.exists(mobile) {
                onError(CoreDataError.failedToSaveObject)
                return
            }
            do {
                let _ = try mobileStorage.save(mobile)
                onSuccess()
            } catch let error as DescribedError {
                onError(error)
            } catch {
                onError(CoreDataError.failedToSaveObject)
            }
            return
        }
    }
}
