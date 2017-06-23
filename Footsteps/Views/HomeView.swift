//
//  HomeView.swift
//  Footsteps
//
//  Created by John Gibb on 6/19/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class HomeView: UIView, StatelessComponent {
    required init?(coder aDecoder: NSCoder) { fatalError() }

    struct Props {
        let results: [Destination]
        let didUpdateSearchText: ((String) -> Void)?
        let didSelectResult: ((Destination) -> Void)?
    }

    let searchTextView = SearchTextView()
    let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        fillWith(UIStackView(arrangedSubviews: [
            searchTextView,
            tableView
        ], axis: .vertical))
        searchTextView.addConstraint(.height, .equal, 50)

        initTableView()

        backgroundColor = .white
    }

    func update(oldProps: Props?, props: Props) {
        searchTextView.props = SearchTextView.Props(
            didUpdateText: props.didUpdateSearchText,
            didFocus: nil
        )
        tableView.reloadData()
    }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DestinationTableViewCell.self, forCellReuseIdentifier: "Destination")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Destination") as! DestinationTableViewCell
        let destination = props!.results[indexPath.row]
        cell.props = DestinationTableViewCell.Props(
            name: destination.name,
            address: destination.address
        )
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props?.results.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let props = props else { return }
        let destination = props.results[indexPath.row]
        props.didSelectResult?(destination)
    }
}
