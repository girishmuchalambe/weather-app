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
    
    func fetchWeather(city:String, appKey: String, completionHandler: @escaping (WAAPIResult<Any>) -> Void)
    func fetchUsersCurrentCity(latitude: Double, longitude: Double, appKey: String, limit:Int, completionHandler: @escaping (WAAPIResult<Any>) -> Void)
}

class WAHomeViewModel: WAHomeViewModelProtocol {
    func fetchUsersCurrentCity(limit: Int, latitude: Double, longitude: Double, completionHandler: @escaping (WAAPIResult<Any>) -> Void) {
        
    }
    
    
    private var apiService: WAAPIService
    private var weatherModel: Weather?
    
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
        "\(String(describing: weatherModel?.main?.temp ?? 0.0)) ".appending(WAConstants.Symbol.degree)
    }
    var minimumTemperature: String {
        "\(String(describing: weatherModel?.main?.tempMin ?? 0.0)) ".appending(WAConstants.Symbol.degree)
    }
    var maximumTemperature: String {
        "\(String(describing: weatherModel?.main?.tempMax ?? 0.0)) ".appending(WAConstants.Symbol.degree)
    }
    
    var weatherDescription: String {
        weatherModel?.weather?.first?.description ?? ""
    }
    
    var lastSearchCity: String {
        UserDefaults.standard.string(forKey: WAConstants.Storage.LAST_SEACHED_CITY) ?? ""
    }
    
    var wind: Wind? {
        weatherModel?.wind
    }
    
    var numberOfRows: Int {
        weatherModel?.wind == nil ? 0 : 1
    }
    
    var latitude: Double {
        WALocationService.shared.location?.coordinate.latitude ?? 0.0
    }
    
    var longitude: Double {
        WALocationService.shared.location?.coordinate.longitude ?? 0.0
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
        let queryString = "?q=\(String(describing: cityText))&appid=\(appKey)&units=metric"
        
        let endpoint = WAWeatherEndPoint.getWeather(parameter: queryString)
        
        apiService.request(from: endpoint) { [weak self] (response) in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                self.weatherModel = try? WAJSONParser.parseResponse(from: data, type: Weather.self)
                UserDefaults.standard.set(city, forKey: WAConstants.Storage.LAST_SEACHED_CITY)
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
        let queryString = "?limit=1&lat=\(latitude)&lon=\(longitude)&appid=\(appKey)"
        
        let endpoint = WAWeatherEndPoint.getUserLocation(parameter: queryString)
        
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
