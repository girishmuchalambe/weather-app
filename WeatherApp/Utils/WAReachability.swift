//
//  Reachability.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import Foundation

import Network

protocol WANetworkCheckObserver: AnyObject {
    func statusDidChange(status: NWPath.Status)
}

class WANetworkCheck {

    struct WANetworkChangeObservation {
        weak var observer: WANetworkCheckObserver?
    }

    private var monitor = NWPathMonitor()
    static let shared = WANetworkCheck()
    private var observations = [ObjectIdentifier: WANetworkChangeObservation]()
    var currentStatus: NWPath.Status {
        get {
            return monitor.currentPath.status
        }
    }
    
    private init() {
        monitor.pathUpdateHandler = { [unowned self] path in
            for (id, observations) in self.observations {

                //If any observer is nil, remove it from the list of observers
                guard let observer = observations.observer else {
                    self.observations.removeValue(forKey: id)
                    continue
                }

                DispatchQueue.main.async(execute: {
                    observer.statusDidChange(status: path.status)
                })
            }
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
}

extension WANetworkCheck {
    private func addObserver(observer: WANetworkCheckObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = WANetworkChangeObservation(observer: observer)
    }

    private func removeObserver(observer: WANetworkCheckObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }
}
