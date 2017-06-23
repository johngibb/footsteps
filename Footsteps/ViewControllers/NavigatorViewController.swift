//
//  NavigatorViewController.swift
//  Footsteps
//
//  Created by John Gibb on 6/23/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import Foundation
import UIKit

class NavigatorViewController: UIViewController, Component {
    struct Props {
        let destination: Destination
    }
    struct State {
        var distance: String
    }

    func getInitialState() -> NavigatorViewController.State {
        return State(distance: "3.6 mi")
    }

    lazy var navigatorView: NavigatorView = NavigatorView()
    override func loadView() {
        view = navigatorView
    }

    func update(oldProps: NavigatorViewController.Props?, props: NavigatorViewController.Props) {
        navigatorView.props = NavigatorView.Props(
            destination: props.destination,
            distance: state.distance
        )
    }
}
