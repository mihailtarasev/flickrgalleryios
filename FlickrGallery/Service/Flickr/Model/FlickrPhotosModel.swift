//
//  FlickrPhotosModel.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 12/9/2023.
//

import Foundation

struct FlickrPhotosModel: Decodable {
    var page: Int
    var pages: Int
    var photo: Array<FlickrPhotoModel>

    enum CodingKeys: CodingKey {
        case page
        case pages
        case photo
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decode(Int.self, forKey: CodingKeys.page)
        pages = try container.decode(Int.self, forKey: CodingKeys.pages)
        photo = try container.decode(Array<FlickrPhotoModel>.self, forKey: CodingKeys.photo)
    }
}
