//
//  WAHomeViewModelTests.swift
//  WeatherAppTests
//
//  Created by Girish Muchalambe on 12/04/23.
//

import XCTest
@testable import WeatherApp

final class WAHomeViewModelTests: XCTestCase {
    var apiService: WAAPIService!
    var viewModel: WAHomeViewModelProtocol!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testFetchWeather() {
        let apiManagerSuccess = expectation(description: "apiservicesuccess")
        let expectedData = WANetworkSessionHelper.getResponseData(for: "weather_ok")
        
        let response = WANetworkSessionHelper.getUrlResponse(responseType: .success)
        let session = WANetworkSessionMock.init(data: expectedData, response: response, error: nil)
        apiService = WAAPIService(session: session)
        viewModel = WAHomeViewModel(apiService: apiService)
        
        viewModel.fetchWeather(city: "Zocca", appKey: "1234") { result in
            switch result {
            case .success(_):
                XCTAssertEqual("Zocca", self.viewModel.cityName)
                XCTAssertEqual("overcast clouds".capitalized, self.viewModel.weatherDescription)
                XCTAssertEqual(280.74.degreeString(), self.viewModel.currentTemperature)
            case .failure( _): break
            }
            apiManagerSuccess.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            guard let _ = error else{ return }
            XCTFail("Expectation Failure")
        }
    }
    
    func testFetchUsersCurrentCity() {
        let apiManagerSuccess = expectation(description: "apiservicesuccess")
        let expectedData = WANetworkSessionHelper.getResponseData(for: "usercity_ok")
        
        let response = WANetworkSessionHelper.getUrlResponse(responseType: .success)
        let session = WANetworkSessionMock.init(data: expectedData, response: response, error: nil)
        apiService = WAAPIService(session: session)
        viewModel = WAHomeViewModel(apiService: apiService)
        
        viewModel.fetchUsersCurrentCity(latitude: 11.11, longitude: 11.11, appKey: "1234", limit:1) { result in
            switch result {
            case .success(let userLocation):
                XCTAssertNotNil(userLocation as? WAUserLocationElement)
                guard let userLocation = userLocation as? WAUserLocationElement else { return }
                
                XCTAssertEqual("City of Westminster", userLocation.name)
                XCTAssertEqual("England", userLocation.state)
                XCTAssertEqual("GB", userLocation.country)
            case .failure( _): break
            }
            apiManagerSuccess.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            guard let _ = error else{ return }
            XCTFail("Expectation Failure")
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        apiService = nil
        viewModel = nil
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
