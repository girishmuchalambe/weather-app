//
//  APIEndpoint.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import Foundation

internal protocol WAAPIEndpoint {
    var pathFragment: String { get }
    var method: RequestMethod { get }
}
