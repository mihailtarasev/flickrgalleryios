//
//  FlickrPhotoModel.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 12/9/2023.
//

import Foundation

struct FlickrPhotoModel: Decodable {
    var id: String
    var title: String
    var smallImageUrl: String?
    var largeImageUrl: String?
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case url_s
        case url_l
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: CodingKeys.id)
        title = try container.decode(String.self, forKey: CodingKeys.title)
        smallImageUrl = try? container.decode(String.self, forKey: CodingKeys.url_s)
        largeImageUrl = try? container.decode(String.self, forKey: CodingKeys.url_l)
    }
}
