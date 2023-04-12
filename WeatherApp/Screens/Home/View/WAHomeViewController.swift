//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import Foundation
import UIKit
import SwiftUI

class WAHomeViewController: UIViewController {
    private enum CellIdentifier: String {
        case moreTableViewCell = "MoreTableViewCell"
    }
    
    var viewModel: WAHomeViewModelProtocol?
    @IBOutlet weak var searchTextField: UITextField?
    @IBOutlet weak var cityNameLabel: UILabel?
    @IBOutlet weak var cloudImageView: UIImageView?
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var minMaxTemperatureLabel: UILabel?
    @IBOutlet weak var weatherDescriptionLabel: UILabel?
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        setupView()
    }
    
    private func setupView() {
        title = WAConstants.Messages.HOME_SCREEN_TITLE
        searchTextField?.delegate = self
        if let lastSearchCity = viewModel?.lastSearchCity {
            if !lastSearchCity.isEmpty {
                fetchWeatherData(withCity: lastSearchCity)
                searchTextField?.text = lastSearchCity
            }
        }
        observeLocation()
        addTapGesture()
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false 
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func observeLocation() {
        WALocationService.shared.statusHandlers.append {
            //TODO: The code for getting the user's city based on current location
        }
    }
    
    private func fetchWeatherData(withCity city: String) {
        showLoading(message: NSLocalizedString(WAConstants.Messages.LOADING_MESSAGE, comment: ""))
        viewModel?.fetchWeather(city: city, completionHandler: {[weak self] result in
            self?.hideLoading()
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.reloadUI()
                }
            case .failure(let error):
                self?.showErrorMessage(errorMessage: error.domain)
            }
        })
    }
    
    private func reloadUI() {
        guard let viewModel = viewModel else { return }
        cityNameLabel?.text = viewModel.cityName
        currentTemperatureLabel?.text = viewModel.currentTemperature
        minMaxTemperatureLabel?.text = "\(WAConstants.Messages.LOW) \(viewModel.minimumTemperature)  /  \(WAConstants.Messages.HIGH) \(viewModel.maximumTemperature) "
        weatherDescriptionLabel?.text = viewModel.weatherDescription
        tableView?.reloadData()
        
        WAImageDownloader.shared.getImage(for: viewModel.imageName, imageNumber: viewModel.imageNumber) {[weak self] image1 in
            DispatchQueue.main.async {
                self?.cloudImageView?.image = image1
            }
        }
    }
    
    private func showErrorMessage(errorMessage: String) {
        alert(message: errorMessage)
    }
}

extension WAHomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let searchText = textField.text else { return true}
        fetchWeatherData(withCity:  searchText)
        return true
    }
}


extension WAHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let moreCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.moreTableViewCell.rawValue, for: indexPath) as? WAMoreTableViewCell else {
            return UITableViewCell()
        }
        moreCell.viewModel = WAConstants.Messages.WIND_INFORMATION
        return moreCell
    }
}

extension WAHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let windInformation = UIHostingController(rootView: WAWindInformation(wind: viewModel?.wind))
        navigationController?.pushViewController(windInformation, animated: true)
    }
}
