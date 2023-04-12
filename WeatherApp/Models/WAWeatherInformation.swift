//
//  WeatherInformationType.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 12/04/23.
//

import Foundation
enum WeatherCellType {
    case wind
    case more
}
struct WeatherInformation {
    var title: String
    var weatherCellType: WeatherCellType
}
