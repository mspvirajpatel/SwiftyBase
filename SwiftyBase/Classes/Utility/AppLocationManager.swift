//
//  AppLocationManager.swift
//  Pods
//
//  Created by MacMini-2 on 31/08/17.
//
//

import Foundation

import CoreLocation

open class AppLocationManager: NSObject, CLLocationManagerDelegate {

    public enum Result {
        case success(AppLocationManager)
        case failure(Error)
    }

    public static let shared: AppLocationManager = AppLocationManager()

    public typealias Callback = (Result) -> Void

    public var requests: Array <Callback> = Array <Callback>()

    public var location: CLLocation? { return sharedLocationManager.location }

    lazy var sharedLocationManager: CLLocationManager = {
        let newLocationmanager = CLLocationManager()
        newLocationmanager.delegate = self
        // ...
        return newLocationmanager
    }()

    // MARK: - Authorization

    class func authorize() { shared.authorize() }
    public func authorize() { sharedLocationManager.requestWhenInUseAuthorization() }

    // MARK: - Helpers

    public func locate(_ callback: @escaping Callback) {
        self.requests.append(callback)
        sharedLocationManager.startUpdatingLocation()
    }

    public func reset() {
        self.requests = Array <Callback>()
        sharedLocationManager.stopUpdatingLocation()
    }

    // MARK: - Delegate

    @nonobjc public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) -> Error {
        for request in self.requests
        {
            request(.failure(error))
        }
        // Show ErrorMessage.noCurrentLocation
        self.reset()

        return error
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: Array <CLLocation>)
    {
        for request in self.requests { request(.success(self)) }
        self.reset()
    }


}
