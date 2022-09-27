//
//  MobileDetailsValidator.swift
//  MobileStorage
//
//  Created by Slik on 27.09.2022.
//

import Foundation

final class MobileDetailsValidator {
    
    private var model: String!
    private var imei: String!
    
    func isValid(model: String, imei: String) -> Bool {
        
        self.model = model
        self.imei = imei
        
        guard !(model.isEmpty && imei.isEmpty) else {
            return false
        }
        
        return isModelSymbolsCountCorrect() &&
        isIMEISymbolsCountCorrect()  &&
        isIMEIFormatCorrect()
    }
    
    private func isModelSymbolsCountCorrect() -> Bool {
        return model.count >= 3
    }
    
    private func isIMEISymbolsCountCorrect() -> Bool {
        return (15...17).contains(imei.count)
    }
    
    private func isIMEIFormatCorrect() -> Bool {
        return imei.allSatisfy { $0.isNumber }
    }
}
