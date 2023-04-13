//
//  WeatherEndPoint.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import Foundation

enum WAWeatherEndPoint: WAAPIEndpoint
 {
    // Get the weather information from city
    case getWeather(parameters: [String:String])
    // Get user city from current location
    case getUserLocation(parameters: [String:String])
    
    var pathFragment: String {
        switch self {
        case let .getWeather(parameters):
            return "data/2.5/weather?".appending(getQueryParamerters(parameters: parameters))
        case let .getUserLocation(parameters):
            return "geo/1.0/reverse?".appending(getQueryParamerters(parameters: parameters))
        }
    }

    var method: RequestMethod {
        switch self {
        case .getWeather, .getUserLocation: return .get
        }
    }
    
    private func getQueryParamerters(parameters: [String: String]) -> String {
        var queryString = ""
        for (key, value) in parameters {
            queryString.append("\(key)=\(value)&")
        }
        queryString.append("appid=\(WAConstants.API.APPKEY)")
        return queryString
    }
}
