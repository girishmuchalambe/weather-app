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
    
    var pathFragment: String {
        switch self {
        case let .getWeather(parameter): return "weather?\(parameter)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getWeather: return .get
        }
    }
}
