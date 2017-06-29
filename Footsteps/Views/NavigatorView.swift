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
        let didTapCancel: ((Void) -> Void)?
    }

    let arrowView = ArrowView()
    let destinationLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let topRow = makeTopRow()
        addSubviews(arrowView, topRow)
        arrowView.pinToCenterOfContainer()
        backgroundColor = Style.backgroundColor
        topRow.pinToContainer(top: 20, left: 20, right: 20)
        destinationLabel.textColor = Style.foregroundColor
        destinationLabel.numberOfLines = 0
    }

    func makeTopRow() -> UIView {
        let closeIcon = UIButton(type: .custom).tap {
            $0.setImage(UIImage(named: "button-cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = Style.foregroundColor
            $0.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
            $0.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
            $0.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        }
        return UIStackView(arrangedSubviews: [destinationLabel, closeIcon], axis: .horizontal).tap {
            $0.distribution = .fill
        }
    }

    func update(oldProps: NavigatorView.Props?, props: NavigatorView.Props) {
        arrowView.props = ArrowView.Props(distance: props.distance)
        destinationLabel.text = props.destination.name + "\n" + props.destination.address
    }

    func didTapCancel() {
        props?.didTapCancel?()
    }
}
