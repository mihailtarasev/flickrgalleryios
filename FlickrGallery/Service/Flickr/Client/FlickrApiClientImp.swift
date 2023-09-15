//
//  FlickrApiClientImp.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 12/9/2023.
//

import Foundation

class FlickrApiClientImp {
    private var baseUrl: String
    private var apiKey: String
    private let httpRequestService = HttpRequestService()
    private let parser = FlickrHttpResponseParser()
    
    init(baseUrl: String, apiKey: String) {
        self.baseUrl = baseUrl
        self.apiKey = apiKey
    }
    
    func getPhotoPageRequest(text: String, perPage: Int, page: Int) async throws -> FlickrResponseModel {
        let immutablePart = "/services/rest/?method=flickr.photos.search&extras=url_s,url_l%2C&format=json&nojsoncallback=1"
        let requestUrl = "\(baseUrl)\(immutablePart)&api_key=\(apiKey)&text=\(text)&per_page=\(perPage)&page=\(page)"
        let response = try await httpRequestService.request(requestUrl)
        let parsed = try parser.parseGetPhotosSearchResponse(response)
        return parsed
    }
}
