//
//  UIApplication.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import UIKit

extension UIApplication {
    func openURL(string: String?) {
        guard let urlString = string?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) else {
            return
        }
        UIApplication.shared.open(url)
    }
}
