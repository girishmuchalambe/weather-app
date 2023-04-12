//
//  NetworkSessionMock.swift
//  WeatherAppTests
//
//  Created by Girish Muchalambe on 12/04/23.
//

import Foundation
@testable import WeatherApp

class WANetworkSessionMock: NetworkSession {
    
    var data: Data?
    var error: Error?
    var response: URLResponse?
    var isRequesting: Bool = false
    
    init() {
        
    }
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.error = error
        self.response = response
    }
    
    func loadData(from request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        isRequesting = true
        completionHandler(data, response, error)
    }
}
