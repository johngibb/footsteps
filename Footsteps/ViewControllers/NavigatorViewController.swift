//
//  NavigatorViewController.swift
//  Footsteps
//
//  Created by John Gibb on 6/23/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class NavigatorViewController: UIViewController, Component {
    struct Props {
        let destination: Destination
    }
    struct State {
        var distance: CLLocationDistance?
        var rotation: CGFloat?
    }

    func getInitialState() -> NavigatorViewController.State {
        return State(
            distance: nil,
            rotation: nil
        )
    }

    lazy var navigatorView: NavigatorView = NavigatorView()

    override func loadView() {
        view = navigatorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationStore.enable()
        locationStore.didUpdate.subscribe(on: self, NavigatorViewController.didUpdateLocation)
    }

    func update(oldProps: NavigatorViewController.Props?, props: NavigatorViewController.Props) {
        let distanceFormatter = MKDistanceFormatter() // TODO: Investigate MeasurementFormatter to remove MapKit dependency
        distanceFormatter.unitStyle = .abbreviated

        navigatorView.props = NavigatorView.Props(
            destination: props.destination,
            distance: state.distance.map(distanceFormatter.string) ?? "-",
            didTapCancel: {[weak self] in self?.didTapCancel()}
        )

        UIView.animate(withDuration: 0.1) {
            self.navigatorView.arrowView.transform = CGAffineTransform.identity.rotated(by: self.state.rotation ?? 0)
        }
    }

    func didUpdateLocation() {
        guard let props = props else { return }
        let heading = locationStore.heading
        let location = locationStore.location

        if let heading = heading, let location = location {
            let routeHeading = getBearingBetweenTwoPoints1(point1: location, point2: props.destination.location)
            state.rotation = CGFloat(degreesToRadians(degrees: routeHeading - heading.trueHeading))
        } else {
            state.rotation = nil
        }

        state.distance = location.map{$0.distance(from: props.destination.location)}
    }

    func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }

    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> CLLocationDirection {

        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)

        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}
