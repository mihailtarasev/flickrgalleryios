//
//  FlickrHttpResponseParser.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 13/9/2023.
//

import Foundation

class FlickrHttpResponseParser {
    private let decoder = JSONDecoder()
    
    func parseGetPhotosSearchResponse(_ httpResponse: Data) throws -> FlickrResponseModel {
        return try decoder.decode(FlickrResponseModel.self, from: httpResponse)
    }
}
