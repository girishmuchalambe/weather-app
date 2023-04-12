//
//  HomeRouter.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import Foundation
import UIKit

struct WAHomeRouter {
    static func getHomeViewController() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let homeViewController: WAHomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? WAHomeViewController else { return nil }
        homeViewController.viewModel = WAHomeViewModel()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        
        return navigationController
    }
}
