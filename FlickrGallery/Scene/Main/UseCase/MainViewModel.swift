//
//  MainViewModel.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 12/9/2023.
//

import Foundation

class MainViewModel: NSObject {
    static let defaultText = "ship"
    static let defaultPerPage = 40
    static let defaultCurrentPage = 0
    static let defaultPhotoPages = 1
    static let defaultIsRefreshing = false
    static let defaultPhotoList = Array<MainPhotoModel>()
    
    @objc dynamic var pageClearedObservable = NSNumber()
    @objc dynamic var photoListUpdatedObservable = NSMutableArray()
    @objc dynamic var isEndRefreshingObservable = NSNumber()
    @objc dynamic var isAlertFiredObservable = NSString()

    private let networkGateway = MainNetworkGatewayImp()
    private var model = MainModel(
        text: defaultText,
        currentPageNumber: defaultCurrentPage,
        photoPages: defaultPhotoPages,
        photoList: defaultPhotoList,
        isRefreshing: defaultIsRefreshing
    )
    
    func uploadFirstPage() {
        if(isNextPageWillFirst()) {
            uploadNextAvailablePage()
        }
    }

    func updateNotFilteredClearedPage() {
        if(isNotFiltered()) {
            updateClearedPage()
        }
    }

    func updateClearedPage() {
        clearPage()
        uploadNextAvailablePage()
    }
    
    func uploadNextAvailablePage() {
        if (model.isAvailableNextPage()) {
            Task {
                do {
                    let networkGatewayModel = try await getNextPhotoPage()
                    model.updateBy(networkGatewayModel)
                    emitPhotoListToObserver()
                } catch let error {
                    emitIsAlertFired(error.localizedDescription)
                }
                emitIsEndRefreshing()
            }
        } else {
            emitIsEndRefreshing()
        }
    }
    
    func setFilterWithDefault(text: String?, defaultText: String = defaultText) { model.text = text ?? defaultText }

    private func getNextPhotoPage() async throws -> MainNetworkModel {
        let nextPageNumber = model.currentPageNumber + 1
        let text = !model.text.isEmpty ? model.text : MainViewModel.defaultText
        return try await networkGateway.getPhotoPageRequest(text: text, perPage: MainViewModel.defaultPerPage, page: nextPageNumber)
    }
    
    private func clearPage() {
        model.clearPage()
        emitPageClearedEventToObserver()
    }

    private func isNotFiltered() -> Bool {
        return model.text.isEmpty
    }

    private func isNextPageWillFirst() -> Bool {
        return model.photoList.isEmpty
    }
    
    private func emitIsAlertFired(_ text: String) {
        isAlertFiredObservable = text as NSString
    }

    private func emitIsEndRefreshing() {
        isEndRefreshingObservable = true
    }

    private func emitPhotoListToObserver() {
        let photoList = model.photoList
        photoListUpdatedObservable = NSMutableArray(array: photoList)
    }

    private func emitPageClearedEventToObserver() {
        pageClearedObservable = true
    }
}
