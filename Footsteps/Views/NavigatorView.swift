//
//  NavigatorView.swift
//  Footsteps
//
//  Created by John Gibb on 6/23/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import Foundation
import UIKit

class NavigatorView: UIView, StatelessComponent {
    required init?(coder aDecoder: NSCoder) { fatalError() }

    struct Props {
        let destination: Destination
        let distance: String
//        let rotation: CGFloat
    }

    let arrowView = ArrowView()
    let destinationLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(arrowView, destinationLabel)
        arrowView.pinToCenterOfContainer()
        backgroundColor = Style.backgroundColor
        destinationLabel.pinToContainer(top: 20, left: 20)
        destinationLabel.textColor = Style.foregroundColor
        destinationLabel.numberOfLines = 0
    }

    func update(oldProps: NavigatorView.Props?, props: NavigatorView.Props) {
        arrowView.props = ArrowView.Props(distance: props.distance)
        destinationLabel.text = props.destination.name + "\n" + props.destination.address
    }
}
