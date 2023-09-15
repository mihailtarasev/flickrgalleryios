//
//  FlickrGateway.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 12/9/2023.
//

import Foundation

class FlickrGateway {
    private let apiClient:FlickrApiClientImp
    
    static func create(baseUrl: String, apiKey: String) -> FlickrGateway {
        let apiClient = FlickrApiClientImp(baseUrl: baseUrl, apiKey: apiKey)
        return FlickrGateway(apiClient: apiClient)
    }
    
    init(apiClient:FlickrApiClientImp) {
        self.apiClient = apiClient
    }
    
    func getPhotoPageRequest(text: String, perPage: Int, page: Int) async throws -> FlickrResponseModel {
        return try await apiClient.getPhotoPageRequest(text: text, perPage: perPage, page: page)
    }
}
