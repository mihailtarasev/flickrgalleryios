//
//  MainCollectionViewControllerDelegate.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 14/9/2023.
//

import Foundation

protocol MainCollectionViewControllerDelegate: AnyObject {
    func collectionViewDidSelectItemAt(imageUrl: String)
    
    func collectionViewUploadNextPage()
}
