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
    
    var onDelete: () -> () = { }

    var onError: (DescribedError) -> () = { _ in }

    private var cachedRepresentedData: [Mobile] = []

    private var mobileStorage: MobileStorage = CoreDataMobileStorage()
    
    init() {
        observeCoreDataContextChanges()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
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
            onDelete()
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
        let builder = MobileDetailsMVVMModuleBuilder(.coreData, mode: .add)
        NavigationControllerManager.shared.push(vc: builder.build())
    }
}
//MARK: - Select
extension MobileListViewModel {
    func select(atIndex index: Int) {
        let builder = MobileDetailsMVVMModuleBuilder(.coreData, mode: .update(representedData[index].imei))
        NavigationControllerManager.shared.push(vc: builder.build())
    }
}
//MARK: - CoreData context observation
extension MobileListViewModel {
    private func observeCoreDataContextChanges() {
        NotificationCenter.default.addObserver(forName: CoreDataContextHolder.storageDidChangeNotification,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            self?.fetch()
            self?.onDataUpdated()
        }
    }
}
