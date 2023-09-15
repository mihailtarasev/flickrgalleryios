//
//  HttpRequestService.swift
//  FlickrGallery
//
//  Created by mihailtarasev on 12/9/2023.
//

import Foundation

class HttpRequestService {
    
    typealias parameters = [String:Any]
    
    enum ApiResult {
        case success(Data)
        case failure(RequestError)
    }
    enum HTTPMethod: String {
        case get = "GET"
    }
    enum RequestError: Error {
        case unknownError
        case connectionError
        case serverError
        case authorizationError(Data)
    }
    
    func request(_ requestUrl: String) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            requestData(url: requestUrl, method: HTTPMethod.get) { response in
                switch response {
                case ApiResult.success(let data):
                    continuation.resume(returning: data)
                case ApiResult.failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func requestData(url:String,method:HTTPMethod,completion: @escaping (ApiResult)->Void) {
        let header =  ["Content-Type": "application/x-www-form-urlencoded"]
        var urlRequest = URLRequest(url: URL(string: url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpMethod = method.rawValue

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
                completion(ApiResult.failure(.connectionError))
            }else if let data = data ,let responseCode = response as? HTTPURLResponse {
                print("responseCode : \(responseCode.statusCode)")
                switch responseCode.statusCode {
                case 200:
                completion(ApiResult.success(data))
                case 400...499:
                completion(ApiResult.failure(.authorizationError(data)))
                case 500...599:
                completion(ApiResult.failure(.serverError))
                default:
                    completion(ApiResult.failure(.unknownError))
                    break
                }
            }
        }.resume()
    }
}
