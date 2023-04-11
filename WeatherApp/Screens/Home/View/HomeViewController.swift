//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import Foundation
import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    enum CellIdentifier: String {
        case moreTableViewCell = "MoreTableViewCell"
       
    }
    
    var viewModel: HomeViewModelProtocol = HomeViewModel()
    @IBOutlet weak var searchTextField: UITextField?
    @IBOutlet weak var cityNameLabel: UILabel?
    @IBOutlet weak var cloudImageView: UIImageView?
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var minMaxTemperatureLabel: UILabel?
    @IBOutlet weak var weatherDescriptionLabel: UILabel?
    
    override func viewDidLoad() {
        setupView()
    }
    
    private func setupView() {
        title = Constanst.Messages.HOME_SCREEN_TITLE
        searchTextField?.delegate = self
        let lastSearchCity = viewModel.lastSearchCity
        if !lastSearchCity.isEmpty {
            fetchWeatherData(withCity: lastSearchCity)
            searchTextField?.text = lastSearchCity
        }
        observeLocation()
    }
    
    private func observeLocation() {
        LocationManager.shared.statusHandlers.append {
            //TODO: The code for getting the user's city based on current location
        }
    }
    
    private func fetchWeatherData(withCity city: String) {
        showLoading(message: NSLocalizedString(Constanst.Messages.LOADING_MESSAGE, comment: ""))
        viewModel.fetchWeather(city: city, completionHandler: {[weak self] result in
            self?.hideLoading()
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.reloadUI()
                }
            case .failure(let error):
                self?.showErrorMessage(errorMessage: error.localizedDescription)
            }
        })
    }
    
    private func reloadUI() {
        cityNameLabel?.text = viewModel.cityName
        currentTemperatureLabel?.text = viewModel.currentTemperature
        minMaxTemperatureLabel?.text = "\(Constanst.Messages.LOW) \(viewModel.minimumTemperature)  /  \(Constanst.Messages.HIGH) \(viewModel.minimumTemperature) "
        weatherDescriptionLabel?.text = viewModel.weatherDescription
        ImageDownloader.shared.getImage(for: viewModel.imageName, imageNumber: viewModel.imageNumber) {[weak self] image1 in
            DispatchQueue.main.async {
                self?.cloudImageView?.image = image1
            }
        }
    }

    private func showErrorMessage(errorMessage: String) {
        alert(message: errorMessage)
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let searchText = textField.text else { return true}
        fetchWeatherData(withCity:  searchText)
        return true
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let moreCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.moreTableViewCell.rawValue, for: indexPath) as? MoreTableViewCell else {
            return UITableViewCell()
        }
        moreCell.viewModel = Constanst.Messages.WIND_INFORMATION
        return moreCell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let windInformation = UIHostingController(rootView: WindInformation(wind: viewModel.wind))
        navigationController?.pushViewController(windInformation, animated: true)
    }
}
