//
//  ModelProtocol.swift
//  MobileStorage
//
//  Created by Slik on 20.09.2022.
//

import Foundation

protocol MobileModel : Hashable {
    var imei: String { get set }
    var model: String { get set }
}
