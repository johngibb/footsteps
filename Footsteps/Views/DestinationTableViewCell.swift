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
    required init?(coder aDecoder: NSCoder) { fatalError() }

    struct Props {
        let name: String
        let address: String
    }

    let content = UIView()
    let nameLabel = UILabel().tap { $0.numberOfLines = 0 }
    let addressLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        contentView.fillWith(content, insets: UIEdgeInsets(top: 0, left: 0, bottom: Style.betweenResultSpacing, right: 0))

        content.fillWith(UIStackView(arrangedSubviews: [nameLabel, addressLabel]).tap {
            $0.axis = .vertical
        }, insets: Style.resultInsets)
    }

    func update(oldProps: DestinationTableViewCell.Props?, props: DestinationTableViewCell.Props) {
        nameLabel.attributedText = props.name.with(style: Style.resultNameStyle)
        addressLabel.attributedText = props.address.with(style: Style.resultAddressStyle)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        content.backgroundColor = selected ? Style.resultBackgroundColorSelected : Style.resultBackgroundColor
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        content.backgroundColor = highlighted ? Style.resultBackgroundColorSelected : Style.resultBackgroundColor
    }
}
