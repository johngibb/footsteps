//
//  DestinationTableViewCell.swift
//  Footsteps
//
//  Created by John Gibb on 6/23/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import Foundation
import UIKit

class DestinationTableViewCell: UITableViewCell, StatelessComponent {
    struct Props {
        let name: String
        let address: String
    }


    func update(oldProps: DestinationTableViewCell.Props?, props: DestinationTableViewCell.Props) {
        textLabel?.text = props.name + "\n" + props.address
        textLabel?.numberOfLines = 0
        detailTextLabel?.text = props.address
    }
}
