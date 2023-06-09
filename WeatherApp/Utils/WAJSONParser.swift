//
//  WAJSONParser.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 12/04/23.
//

import Foundation

struct WAJSONParser {
    // Generic method to parse the JSON to given Model
    static func parseResponse<T : Decodable>(from data:Data?, type: T.Type) throws -> T? {
        guard let weatherData = data else { return nil }
        return try? JSONDecoder().decode(T.self, from: weatherData)
    }
}
