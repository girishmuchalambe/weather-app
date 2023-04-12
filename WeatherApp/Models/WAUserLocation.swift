//
//  WAUserLocation.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 12/04/23.
//

import Foundation
struct WAUserLocationElement: Codable {
    let name: String
    let lat, lon: Double
    let country, state: String
}

typealias WAUserLocation = [WAUserLocationElement]
