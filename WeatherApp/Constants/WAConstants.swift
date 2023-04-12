//
//  Constants.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import Foundation
struct WAConstants{
    struct API {
        static let BASEURL = "https://api.openweathermap.org/data/2.5/"
        static let APPKEY = "310235c5bb0f66c95e9fcf4ab04340ba"
        static let WEATHER_CONDITION_IMAGE_BASEURL = "https://openweathermap.org/img/wn/%@@2x.png"
    }
    
    struct Messages {
        static let API_FAILED_ERROR = NSLocalizedString(WAConstants.Localization.API_FAILED_ERROR, comment: "")
        static let NO_INTERNET_CONNECTION = NSLocalizedString(WAConstants.Localization.NO_INTERNET_CONNECTION, comment: "")
        static let EMAIL_APP_ERROR = NSLocalizedString(WAConstants.Localization.EMAIL_APP_ERROR, comment: "")
        static let LOADING_MESSAGE = NSLocalizedString(WAConstants.Localization.LOADING_MESSAGE, comment: "")
        static let HOME_SCREEN_TITLE = NSLocalizedString(WAConstants.Localization.HOME_SCREEN_TITLE, comment: "")
        static let WIND_INFORMATION = NSLocalizedString(WAConstants.Localization.WIND_INFORMATION, comment: "")
        static let OK = NSLocalizedString(WAConstants.Localization.OK, comment: "")
        static let LOW = NSLocalizedString(WAConstants.Localization.LOW, comment: "")
        static let HIGH = NSLocalizedString(WAConstants.Localization.HIGH, comment: "")
    }
    
    struct Localization {
        static let NO_INTERNET_CONNECTION = "noInternetConnection"
        static let API_FAILED_ERROR = "APIFailed"
        static let EMAIL_APP_ERROR = "emailAppError"
        static let LOADING_MESSAGE = "loadingMessage"
        static let HOME_SCREEN_TITLE = "home_navigation_title"
        static let WIND_INFORMATION = "windInformation"
        static let OK = "ok"
        static let LOW = "low"
        static let HIGH = "high"
    }
    
    struct Storage {
        static let LAST_SEACHED_CITY = "LastSearchCity"
    }
}
