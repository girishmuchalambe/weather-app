//
//  WAAPIService.swift
//  WeatherAppTests
//
//  Created by Girish Muchalambe on 12/04/23.
//

import XCTest
@testable import WeatherApp

final class WAAPIServiceTests: XCTestCase {
    var apiService: WAAPIService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        apiService = nil
    }
    
    func testRequestURL() {
        let session = WANetworkSessionMock()
        apiService = WAAPIService(session: session)
        let endpoint = WAEndpointMock.getMockRequest
        apiService.request(from: endpoint) { (response) in }
        XCTAssertTrue(session.isRequesting)
    }
    
    func testAPIServiceSuccess() {
        let apiManagerSuccess = expectation(description: "apiservicesuccess")
        let expectedData = "[{}]".data(using: .utf8)
        
        let response = WANetworkSessionHelper.getUrlResponse(responseType: .success)
        let session = WANetworkSessionMock.init(data: expectedData, response: response, error: nil)
        apiService = WAAPIService(session: session)
        let endpoint = WAEndpointMock.getMockRequest
        apiService.request(from: endpoint) { (response) in
            switch response {
            case .failure( _):
                XCTFail("Fail error not expected")
            case .success(let data):
                XCTAssertNotNil(data)
                XCTAssertEqual(data, expectedData)
            }
            apiManagerSuccess.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            guard let _ = error else{ return }
            XCTFail("Expectation Failure")
        }
    }
    
    func testAPIManagerFail() {
        let apiManagerFail = expectation(description: "apimanagerfail")
        let error = WANetworkSessionHelper.getError()
        let response = WANetworkSessionHelper.getUrlResponse(responseType: .fail)
        let session = WANetworkSessionMock.init(data: nil, response: response, error: error)
        apiService = WAAPIService(session: session)
        
        let endpoint = WAEndpointMock.getMockRequest
        apiService.request(from: endpoint) { (response) in
            switch response {
            case .failure(let error):
                var errorString : String{
                    return WANetworkCheck.shared.currentStatus == .unsatisfied ?
                    NSLocalizedString(WAConstants.Messages.NO_INTERNET_CONNECTION, comment: "") : NSLocalizedString(WAConstants.Messages.API_FAILED_ERROR, comment: "")
                }
                XCTAssertEqual(error.domain, errorString)
                XCTAssertEqual(error.code, 400)
            case .success( _):
                XCTFail("Fail data not expected")
            }
            apiManagerFail.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            guard let _ = error else{ return }
            XCTFail("Expectation Failure")
        }
    }
   

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
