//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import CoreLocation
import UIKit

typealias LocationUpdated = ( (_ location: CLLocation) -> Void )
typealias EmptyHandler = ( () -> Void )

enum LocationUsageType {
    case whenInUse
    case always
}

class WALocationService: NSObject {
    static let shared = WALocationService()

    private var manager = CLLocationManager()
    private var handlers: [LocationUpdated] = []
    
    var isAuthorized: Bool {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        
        }
    }

    var statusHandlers: [EmptyHandler] = []

    var location: CLLocation? {
        didSet { handleLocation() }

    }

    private override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.pausesLocationUpdatesAutomatically = true
        startMonitoring()
    }

    func startMonitoring() {
        if !isAuthorized {
            manager.stopUpdatingLocation()
            return
        }
        manager.startUpdatingLocation()
    }

    private func handleLocation() {
        guard let location = location else { return }
        for handler in handlers {
            handler(location)
        }
    }

    func requestAuthorizationIfNeeded(_ type: LocationUsageType = .whenInUse) {
        switch type {
        case .whenInUse:
            manager.requestWhenInUseAuthorization()
        case .always:
            manager.requestAlwaysAuthorization()
        }
    }

    func subscribe(handler: @escaping LocationUpdated) {
        handlers.append(handler)
        handleLocation()
    }

    func openSettings() {
        UIApplication.shared.openURL(string: UIApplication.openSettingsURLString)
    }
}

extension WALocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else { return }
        location = last
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        startMonitoring()
        for handler in statusHandlers {
            handler()
        }
    }
}
