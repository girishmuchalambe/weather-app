//
//  APIEndpoint.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import Foundation

internal protocol APIEndpoint {
    var pathFragment: String { get }
    var method: RequestMethod { get }
}
