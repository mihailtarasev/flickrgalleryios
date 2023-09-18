//
//  MainModel.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 18/9/2023.
//

struct MainModel {
    var text: String
    var currentPageNumber: Int
    var photoPages: Int
    var photoList: Array<MainPhotoModel>
    var isRefreshing: Bool
}

extension MainModel {
    
    mutating func updateBy(_ result: MainNetworkModel) {
        photoPages = result.photoPages
        photoList.append(contentsOf: result.photoList)
        currentPageNumber = result.photoPageNumber
    }

    mutating func clearPage() {
        photoList.removeAll()
        currentPageNumber = MainViewModel.defaultCurrentPage
        photoPages = MainViewModel.defaultPhotoPages
    }

    func isAvailableNextPage() -> Bool {
        return currentPageNumber < photoPages
    }
}
