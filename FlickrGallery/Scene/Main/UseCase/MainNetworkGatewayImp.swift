//
//  MainNetworkGatewayImp.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 12/9/2023.
//

import Foundation

class MainNetworkGatewayImp {
    static let apiKey = "c149f0804ae20cb6ee453d66debef32f"
    static let baseUrl = "https://www.flickr.com"
    
    private var flickrGateway = FlickrGateway.create(baseUrl: baseUrl, apiKey: apiKey)
    
    func getPhotoPageRequest(text: String, perPage: Int, page: Int) async throws -> MainNetworkModel {
        let model = try await flickrGateway.getPhotoPageRequest(text: text, perPage: perPage, page: page)
        return MainNetworkModel.create(model)
    }
}
