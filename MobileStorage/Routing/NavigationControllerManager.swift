//
//  NavigationControllerManager.swift
//  MobileStorage
//
//  Created by Slik on 20.09.2022.
//

import UIKit

final class NavigationControllerManager {
    
    static let shared: NavigationControllerManager = {
        return NavigationControllerManager()
    }()
    
    private init() { }
    
    private(set) var navigationController: UINavigationController?
    
    func setNVC(_ nvc: UINavigationController) {
        self.navigationController = nvc
    }
    
    func push(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
