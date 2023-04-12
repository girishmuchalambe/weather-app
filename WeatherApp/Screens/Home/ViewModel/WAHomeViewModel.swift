//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import Foundation

protocol WAHomeViewModelProtocol {
    var cityName: String { get }
    var imageName: String { get }
    var imageNumber: NSNumber { get }
    var currentTemperature: String { get }
    var minimumTemperature: String { get }
    var maximumTemperature: String { get }
    var weatherDescription: String { get }
    var lastSearchCity: String { get }
    var wind: Wind? { get }
    var numberOfRows: Int { get }
    var latitude: Double { get }
    var longitude: Double { get }
    var humidity: Int { get }
    var visibility: Int { get }
    
    func fetchWeather(city:String, appKey: String, completionHandler: @escaping (WAAPIResult<Any>) -> Void)
    func fetchUsersCurrentCity(latitude: Double, longitude: Double, appKey: String, limit:Int, completionHandler: @escaping (WAAPIResult<Any>) -> Void)
    func cellItem(for indexPath: IndexPath) -> WeatherInformation
}

class WAHomeViewModel: WAHomeViewModelProtocol {
    private var apiService: WAAPIService
    private var weatherModel: Weather?
    private var tableCellArray: [WeatherInformation] = []
    
    init(apiService: WAAPIService = WAAPIService()) {
        self.apiService = apiService
        WALocationService.shared.requestAuthorizationIfNeeded()
    }
    
    var cityName: String {
        weatherModel?.name ?? ""
    }
    var imageName: String {
        String(format: WAConstants.API.WEATHER_CONDITION_IMAGE_BASEURL, weatherModel?.weather?.first?.icon ?? "")
    }
    
    var imageNumber: NSNumber {
        NSNumber(value: weatherModel?.weather?.first?.id ?? 0)
    }
    
    var currentTemperature: String {
        weatherModel?.main?.temp?.degreeString() ?? ""
    }
    var minimumTemperature: String {
        weatherModel?.main?.tempMin?.degreeString() ?? ""
    }
    var maximumTemperature: String {
        weatherModel?.main?.tempMax?.degreeString() ?? ""
    }
    
    var weatherDescription: String {
        weatherModel?.weather?.first?.description?.capitalized ?? ""
    }
    
    var lastSearchCity: String {
        UserDefaults.standard.string(forKey: WAConstants.Storage.LAST_SEACHED_CITY) ?? ""
    }
    
    var wind: Wind? {
        weatherModel?.wind
    }
    
    var numberOfRows: Int {
        tableCellArray.count
    }
    
    var latitude: Double {
        WALocationService.shared.location?.coordinate.latitude ?? 0.0
    }
    
    var longitude: Double {
        WALocationService.shared.location?.coordinate.longitude ?? 0.0
    }
    
    var humidity: Int {
        weatherModel?.main?.humidity ?? 0
    }
    
    var visibility: Int {
        (weatherModel?.visibility ?? 0) / 100
    }
    
    func cellItem(for indexPath: IndexPath) -> WeatherInformation {
        tableCellArray[indexPath.row]
    }
    
    private func createTableCellArray() {
        tableCellArray.removeAll()
        if (weatherModel?.wind) != nil {
            tableCellArray.append(WeatherInformation(title: WAConstants.Messages.WIND_INFORMATION, weatherCellType: .wind))
        }
        tableCellArray.append(WeatherInformation(title: WAConstants.Messages.MORE_INFORMATION, weatherCellType: .more))
    }
}

//MARK: API Calling
extension WAHomeViewModel {
    /// Get the weather data based on city provided
    ///
    /// - Parameters:
    /// - city - The input string provided by the user to get the weather information
    ///
    /// - Returns:
    /// It returns the success or failure based on the response recevied from API
    func fetchWeather(city:String, appKey: String, completionHandler: @escaping (WAAPIResult<Any>) -> Void) {
        guard let cityText = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let parameters: [String: String] = ["q": cityText,
                                          "units": "metric"]
        let endpoint = WAWeatherEndPoint.getWeather(parameters: parameters)
        
        apiService.request(from: endpoint) { [weak self] (response) in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                self.weatherModel = try? WAJSONParser.parseResponse(from: data, type: Weather.self)
                UserDefaults.standard.set(city, forKey: WAConstants.Storage.LAST_SEACHED_CITY)
                self.createTableCellArray()
                completionHandler(WAAPIResult.success(nil))
                break
            case .failure(let error):
                completionHandler(WAAPIResult.failure(error))
                break
            }
        }
    }
    
    /// Get the user city based on current location
    ///
    /// - Parameters:
    /// - city - The input string provided by the user to get the weather information
    ///
    /// - Returns:
    /// It returns the success or failure based on the response recevied from API
    func fetchUsersCurrentCity(latitude: Double, longitude: Double, appKey: String, limit: Int, completionHandler: @escaping (WAAPIResult<Any>) -> Void) {
        let parameters: [String: String] = ["limit": "\(limit)",
                                          "lat": "\(latitude)",
                                          "lon": "\(longitude)"]
        let endpoint = WAWeatherEndPoint.getUserLocation(parameters: parameters)
        
        apiService.request(from: endpoint) { (response) in
            switch response {
            case .success(let data):
                let userLocation = try? WAJSONParser.parseResponse(from: data, type: WAUserLocation.self)
                completionHandler(WAAPIResult.success(userLocation?.first))
                break
            case .failure(let error):
                completionHandler(WAAPIResult.failure(error))
                break
            }
        }
    }
}

