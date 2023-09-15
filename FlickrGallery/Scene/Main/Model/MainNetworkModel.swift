//
//  MainNetworkModel.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 12/9/2023.
//

struct MainNetworkModel {
    var photoPageNumber: Int
    var photoPages: Int
    var photoList: Array<MainUseCasePhotoModel>
    
    static func create(_ model: FlickrResponseModel) -> MainNetworkModel {
        let flickrPhotoList = model.photos.photo.compactMap { it in
            if let smallImageUrl = it.smallImageUrl, let largeImageUrl = it.largeImageUrl {
                return MainUseCasePhotoModel(id: it.id, title: it.title, smallImageUrl: smallImageUrl, largeImageUrl: largeImageUrl)
            }
            return nil
        }
        let flickrPhotoPage = model.photos.page
        let flickrPhotoPages = model.photos.pages
        return MainNetworkModel(photoPageNumber: flickrPhotoPage, photoPages: flickrPhotoPages, photoList: Array(flickrPhotoList))
    }
}
