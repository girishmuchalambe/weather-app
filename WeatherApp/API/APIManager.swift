//
//  APIManager.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import Foundation

/// This enum is used  for setting API HTTP request method
public enum RequestMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

/// This enum is used to return the parsed object on successful execution else error
enum APIResult<T>{
    case success(T?)
    case failure(Error)
}

/// This enum is used to return the response data on successful execution else error
enum APIResponse {
    case success(data: Data?)
    case failure(error: Error)
}
class APIManager {
    
    private let session: NetworkSession
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    /// Generic request method for different API request
    ///
    /// - Parameters:
    ///   - endpoint: This contails path fragment and request method used for creating URLRequest object
    /// - Returns:
    ///   - APIResponse - Contains the response data on successful execution else error
    func request(from endpoint: APIEndpoint, completionHandler: @escaping (APIResponse) -> Void){
        let urlString = Constanst.API.BASEURL + endpoint.pathFragment
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        session.loadData(from: request) {[weak self] (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200{
                guard let result = data.map(APIResponse.success) else {return}
                completionHandler(result)
            } else {
                guard let apiError = self?.mapError(error: error) else {return}
                completionHandler(APIResponse.failure(error: apiError))
            }
        }
    }
    
    /// Map error message to user readable format
    ///
    /// - Parameters:
    ///   - error: Error received from API execusion
    /// - Returns:
    ///   - Error - Map the error and return Error object in user readable format
    private func mapError(error: Error?)->Error{
        #if DEBUG
            print("Error code:\(String(describing: error?.code))")
            print("Error description:\(String(describing: error?.localizedDescription))")
        #endif
        let code = error?.code
        var message = ""
        if code == NSURLErrorTimedOut ||
            code == NSURLErrorNotConnectedToInternet ||
            code == NSURLErrorNetworkConnectionLost ||
            code == NSURLErrorResourceUnavailable || !Reachability.isConnectedToNetwork(){
            message = NSLocalizedString(Constanst.Messages.NO_INTERNET_CONNECTION, comment: "")
        } else {
            message = NSLocalizedString(Constanst.Messages.API_FAILED_ERROR, comment: "")
        }
        return NSError(domain: message, code: code ?? -1)
    }
}
