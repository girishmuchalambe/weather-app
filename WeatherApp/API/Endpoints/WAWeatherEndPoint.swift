//
//  WeatherEndPoint.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import Foundation

enum WAWeatherEndPoint: WAAPIEndpoint
 {
    case getWeather(parameter: String)
    case getUserLocation(parameter: String)
    
    var pathFragment: String {
        switch self {
        case let .getWeather(parameter): return "data/2.5/weather\(parameter)"
        case let .getUserLocation(parameter): return "geo/1.0/reverse\(parameter)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getWeather, .getUserLocation: return .get
        }
    }
}
