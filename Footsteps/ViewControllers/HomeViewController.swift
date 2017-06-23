//
//  HomeViewController.swift
//  Footsteps
//
//  Created by John Gibb on 6/19/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, Component {
    let api = SearchAPI()

    lazy var homeView: HomeView = HomeView()
    struct Props {}
    struct State {
        var results: [Destination]
    }

    func getInitialState() -> HomeViewController.State {
        return State(
            results: []
        )
    }

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        state.results = []
        props = Props()
    }

    func update(oldProps: HomeViewController.Props?, props: HomeViewController.Props) {
        homeView.props = HomeView.Props(
            results: state.results,
            didUpdateSearchText: {[weak self] text in
                self?.didUpdateSearchText(text: text)
            },
            didSelectResult: {[weak self] destination in
                self?.didSelectResult(destination: destination)
            }
        )
    }

    func didUpdateSearchText(text: String) {
        api.search(text: text) { results in
            self.state.results = results
        }
    }

    func didSelectResult(destination: Destination) {
        print("didSelectResult \(destination)")
    }


}
