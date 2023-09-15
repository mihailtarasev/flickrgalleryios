//
//  FlickrResponseModel.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 12/9/2023.
//

import Foundation

struct FlickrResponseModel: Decodable {
    var photos: FlickrPhotosModel
    var stat: String
}
