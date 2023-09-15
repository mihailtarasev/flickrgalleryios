//
//  FlickrGatewayTest.swift
//  FlickrGalleryTests
//
//  Created by mihailtarasev on 12/9/2023.
//

import Foundation
import XCTest
import FlickrGallery


class FlickrGatewayTest: XCTestCase {
    private let flickrGateway = FlickrGateway.create(baseUrl: MainNetworkGatewayImp.baseUrl, apiKey: MainNetworkGatewayImp.apiKey)
    
    func testExecute() async {
        let text = "ship"
        let perPage = 10
        let page = 1
        
        do {
            let result = try await flickrGateway.getPhotoPageRequest(text: text, perPage: perPage, page: page)
            XCTAssertTrue(result.photos.page == page)
            XCTAssertTrue(result.photos.photo.count == perPage)
        }catch _ {
            XCTAssertTrue(false)
        }
    }
}
