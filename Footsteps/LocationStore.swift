//
//  LocationStore.swift
//  Footsteps
//
//  Created by John Gibb on 6/23/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

private var _shared = LocationStore()

class LocationStore: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    let didUpdate = Event<Void>()

    var location: CLLocation?
    var heading: CLHeading?

    override init() {
        super.init()
        manager.delegate = self
    }

    func enable() {
        manager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            startUpdating()
        }
    }

    private func startUpdating() {
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            startUpdating()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first!
        didUpdate.emit()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading
        didUpdate.emit()
    }
}

extension UIViewController {
    var locationStore: LocationStore {
        return _shared
    }
}
