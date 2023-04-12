//
//  EndpointMock.swift
//  WeatherAppTests
//
//  Created by Girish Muchalambe on 12/04/23.
//

import Foundation
@testable import WeatherApp

enum WAEndpointMock: WAAPIEndpoint
{
    case getMockRequest
    
    var pathFragment: String {
        switch self {
        case .getMockRequest: return "weather.json"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getMockRequest: return .get
        }
    }
}
