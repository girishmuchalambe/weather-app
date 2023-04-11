//
//  UIViewController.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import UIKit

extension UIViewController{
    
    /// Show loading view until API execution finish or asynchronous task finish
    ///
    /// - Parameters:
    ///   - message: Loading message to be displayed. Defualt will be "Please wait..."
    func showLoading(message: String = Constanst.Messages.LOADING_MESSAGE){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 50),
            loadingIndicator.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor),
            loadingIndicator.leftAnchor.constraint(equalTo: alert.view.leftAnchor, constant: 10)
            ])
        DispatchQueue.main.async {[weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func hideLoading(){
        DispatchQueue.main.async {[weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    /// Show system alert view
    ///
    /// - Parameters:
    ///   - message: Message displayed over alert
    func alert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constanst.Messages.OK, style: .default, handler: nil))
        DispatchQueue.main.async {[weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}