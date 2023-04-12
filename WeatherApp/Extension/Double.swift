//
//  Double.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 12/04/23.
//

import Foundation

extension Double {
    func degreeString() -> String {
        return "\(Int(self.rounded())) ".appending(WAConstants.Symbol.degree)
    }
}
