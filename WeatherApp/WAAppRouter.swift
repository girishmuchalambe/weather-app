//
//  AppRouter.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import Foundation
import UIKit

struct AppRouter {
    static func setInitialView() {
        setRootView(viewController: WAHomeRouter.getHomeViewController())
        UINavigationBar.appearance().tintColor = .black
    }
    
    static func setRootView(viewController: UIViewController?) {
        guard let viewController = viewController else {return}
        AppRouter.getWindow().rootViewController = viewController
        
    }

    static func getWindow() -> UIWindow {
        if let window = (UIApplication.shared.delegate as? AppDelegate)?.window {
            return window
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = .white
            window.makeKeyAndVisible()
            (UIApplication.shared.delegate as? AppDelegate)?.window = window
            return window
        }
    }
}
