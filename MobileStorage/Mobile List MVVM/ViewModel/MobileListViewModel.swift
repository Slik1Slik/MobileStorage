//
//  ViewModel.swift
//  MobileStorage
//
//  Created by Slik on 26.09.2022.
//

import UIKit

protocol MobileListViewModelProtocol : MobileListViewModelInput & MobileListViewModelOutput { }

final class MobileListViewModel : MobileListViewModelProtocol {
    
    var representedData: [Mobile] = []

    var onDataUpdated: () -> () = { }

    var onError: (DescribedError) -> () = { _ in }

    private var cachedRepresentedData: [Mobile] = []

    private var mobileStorage: MobileStorage = CoreDataMobileStorage()
}
//MARK: - Setup
extension MobileListViewModel  {

    func setStorage(_ mobileStorage: MobileStorage) {
        self.mobileStorage = mobileStorage
    }
}
//MARK: - Fetch & Update
extension MobileListViewModel {

    func fetch() {
        representedData = Array(mobileStorage.getAll())
        cachedRepresentedData = representedData
    }
}
//MARK: - Delete
extension MobileListViewModel {

    func remove(atIndex index: Int) {
        do {
            try mobileStorage.delete(representedData[index])
            representedData.remove(at: index)
        } catch let error as DescribedError {
            onError(error)
        } catch {
            return
        }
    }
}
//MARK: - Search
extension MobileListViewModel {

    func search(text: String) {
        guard !text.isEmpty else {
            representedData = cachedRepresentedData
            onDataUpdated()
            return
        }
        representedData = cachedRepresentedData.filter { $0.imei.contains(text) }
        onDataUpdated()
    }
}
//MARK: - Add
extension MobileListViewModel {
    func add() {
        //NavigationControllerManager.shared.navigationController?.present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>)
    }
}
//MARK: - Select
extension MobileListViewModel {
    func select(atIndex index: Int) {
        //NavigationControllerManager.shared.push(vc: )
    }
}
