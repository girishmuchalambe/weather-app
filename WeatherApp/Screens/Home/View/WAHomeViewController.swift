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
        fetchWeatherInformation()
        observeLocation()
        addTapGesture()
    }
    
    // TODO: This method also can be invoked when user brings app to foreground
    private func fetchWeatherInformation() {
        if let lastSearchCity = viewModel?.lastSearchCity, !lastSearchCity.isEmpty {
            fetchWeatherData(withCity: lastSearchCity)
            searchTextField?.text = lastSearchCity
        }else if WALocationService.shared.isAuthorized {
            fetchWeatherFromUserLocation()
        }
    }
    
    // Reload the UI after API response
    private func reloadUI() {
        guard let viewModel = viewModel else { return }
        cityNameLabel?.text = viewModel.cityName
        currentTemperatureLabel?.text = viewModel.currentTemperature
        minMaxTemperatureLabel?.text = "\(WAConstants.Messages.LOW) \(viewModel.minimumTemperature)  /  \(WAConstants.Messages.HIGH) \(viewModel.maximumTemperature) "
        weatherDescriptionLabel?.text = viewModel.weatherDescription
        tableView?.reloadData()
        
        WAImageDownloader.shared.getImage(for: viewModel.imageName, imageNumber: viewModel.imageNumber) {[weak self] image1 in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.cloudImageView?.image = image1
            }
        }
    }

    // Show the error if some issue with the API
    private func showErrorMessage(errorMessage: String) {
        alert(message: errorMessage)
    }
    
    // Show the weather for current for location when user tap on location icon
    @IBAction func showCurrentLocationWeather() {
        view.endEditing(true)
        fetchWeatherFromUserLocation()
    }
}

//MARK: API calling
extension WAHomeViewController {
    // TODO: The loading can be improved by showing loading view once and change the message based on API call
    private func fetchWeatherFromUserLocation() {
        guard let viewModel = viewModel else { return }
        viewModel.fetchUsersCurrentCity(latitude: viewModel.latitude, longitude: viewModel.longitude, limit: 1, completionHandler: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userLocation):
                guard let userLocation = userLocation as? WAUserLocationElement else { return }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.searchTextField?.text = userLocation.name
                    self.fetchWeatherData(withCity: userLocation.name ?? "")
                }
            //TODO: The error information can be shown to user if required
            case .failure(_):break
            }
        })
    }
    
    // Fetch the weather data using city
    private func fetchWeatherData(withCity city: String) {
        showLoading(message: NSLocalizedString(WAConstants.Messages.LOADING_MESSAGE, comment: ""))
        viewModel?.fetchWeather(city: city, completionHandler: {[weak self] result in
            guard let self = self else { return }
            self.hideLoading()
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.reloadUI()
                }
            case .failure(let error):
                self.showErrorMessage(errorMessage: error.domain)
            }
        })
    }
}

//MARK: Location state observer
extension WAHomeViewController {
    // Observer the location status and fetch the user city if location granted
    private func observeLocation() {
        WALocationService.shared.statusHandlers.append { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self?.fetchWeatherFromUserLocation()
            }
        }
    }
}
//MARK: Tap Gesture
extension WAHomeViewController {
    // Added the tap gesture on view to dimiss the keyboard
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: Texfield Delegate
extension WAHomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let searchText = textField.text else { return true}
        fetchWeatherData(withCity:  searchText)
        return true
    }
}



//MARK: Tableview DataSource
extension WAHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let moreCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.moreTableViewCell.rawValue, for: indexPath) as? WAMoreTableViewCell else {
            return UITableViewCell()
        }
        moreCell.viewModel = viewModel?.cellItem(for: indexPath)
        return moreCell
    }
}

//MARK: Tableview Delegate
extension WAHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let informationType = viewModel.cellItem(for: indexPath)
        
        switch informationType.weatherCellType {
        case .wind:
            let windInformation = UIHostingController(rootView: WAWindInformation(wind: viewModel.wind))
            navigationController?.pushViewController(windInformation, animated: true)
        case .more:
            let moreInformation = UIHostingController(rootView: WAMoreInformation(humidity: viewModel.humidity, visibility: viewModel.visibility))
            navigationController?.pushViewController(moreInformation, animated: true)
        }
    }
}
