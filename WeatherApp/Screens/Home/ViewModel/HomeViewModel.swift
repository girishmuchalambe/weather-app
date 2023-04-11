//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import Foundation
protocol HomeViewModelProtocol {
    var cityName: String { get }
    var imageName: String { get }
    var imageNumber: NSNumber { get }
    var currentTemperature: String { get }
    var minimumTemperature: String { get }
    var maximumTemperature: String { get }
    var weatherDescription: String { get }
    var lastSearchCity: String { get }
    var wind: Wind? { get }
    
    func fetchWeather(city:String, completionHandler: @escaping (APIResult<Any>) -> Void)
}

class HomeViewModel: HomeViewModelProtocol {
    private var apiManager: APIManager
    private var weatherModel: Weather?
    
    init(apiManager: APIManager = APIManager()) {
        self.apiManager = apiManager
        LocationManager.shared.requestAuthorizationIfNeeded()
    }
    
    var cityName: String {
        weatherModel?.name ?? ""
    }
    var imageName: String {
        String(format: Constanst.API.WEATHER_CONDITION_IMAGE_BASEURL, weatherModel?.weather?.first?.icon ?? "")
    }
    
    var imageNumber: NSNumber {
        NSNumber(value: weatherModel?.weather?.first?.id ?? 0)
    }
    
    var currentTemperature: String {
        "\(String(describing: weatherModel?.main?.temp ?? 0.0)) F"
    }
    var minimumTemperature: String {
        "\(String(describing: weatherModel?.main?.tempMin ?? 0.0)) F"
    }
    var maximumTemperature: String {
        "\(String(describing: weatherModel?.main?.tempMax ?? 0.0)) F"
    }
    
    var weatherDescription: String {
        weatherModel?.weather?.first?.description ?? ""
    }
    
    var lastSearchCity: String {
        UserDefaults.standard.string(forKey: Constanst.Storage.LAST_SEACHED_CITY) ?? ""
    }
    
    var wind: Wind? {
        weatherModel?.wind
    }
    /// Get the weather data based on city provided
    ///
    /// - Parameters:
    /// - city - The input string provided by the user to get the weather information
    ///
    /// - Returns:
    /// It returns the success or failure based on the response recevied from API
    func fetchWeather(city:String, completionHandler: @escaping (APIResult<Any>) -> Void) {
        
        guard let cityText = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let queryString = "q=\(String(describing: cityText))&appid=\(Constanst.API.APPKEY)"
        
        let endpoint = WeatherEndPoint.getWeather(parameter: queryString)
        
        apiManager.request(from: endpoint) { [weak self] (response) in
            switch response {
            case .success(let data):
                self?.weatherModel = self?.parseResponse(data: data)
                UserDefaults.standard.set(city, forKey: Constanst.Storage.LAST_SEACHED_CITY)
                completionHandler(APIResult.success(nil))
                break
            case .failure(let error):
               completionHandler(APIResult.failure(error))
                break
           }
        }
    }
    
    /// Parse the response received from API
    ///
    /// - Parameters:
    /// - data - The data received from API
    ///
    /// - Returns:
    /// The weather model or nil
    
    func parseResponse(data: Data?)-> Weather?{
        guard let weatherData = data else { return nil }
        do {
            let decoder = JSONDecoder()
            let weatherModel: Weather = try decoder.decode(Weather.self, from: weatherData)
            return weatherModel
        } catch let error {
            #if DEBUG
            print(error.localizedDescription)
            #endif
        }
        return nil
    }
}
