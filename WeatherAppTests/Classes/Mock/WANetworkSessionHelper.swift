//
//  NetworkSessionHelper.swift
//  WeatherAppTests
//
//  Created by Girish Muchalambe on 12/04/23.
//

import Foundation

enum ResponseType {
    case success
    case fail
}
class WANetworkSessionHelper{

    static func getUrlResponse(responseType: ResponseType) -> URLResponse {
        let statusCode = responseType == .success  ? 200 : 400
        return HTTPURLResponse(url: URL(string: "https://mockresponse.com")!, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    static func getResponseData(for filename: String)->Data?{
        let responseData = WAFileUtil(fileName: filename).getData()
        return responseData
    }
    
    static func getError()->Error{
        return NSError(domain: "Something went wrong...please try again", code:  400)
    }
}
