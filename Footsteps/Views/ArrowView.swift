//
//  ArrowView.swift
//  Footsteps
//
//  Created by John Gibb on 6/23/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import Foundation
import UIKit

class ArrowView: UIView, StatelessComponent {

    let labelVerticalOffset = CGFloat(15)

    required init?(coder aDecoder: NSCoder) { fatalError() }

    struct Props {
        let distance: String
    }

    let imageView = UIImageView()
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        fillWith(imageView)
        addSubviews(label)
        label.pinToCenterOfContainer(horizontally: true)
        addConstraint(label, .centerY, .equal, self, .centerY, constant: labelVerticalOffset)
        let image = UIImage(named: "Arrow")!
        imageView.image = image
        constrainToAspectRatio(image.size.width / image.size.height)
        label.textColor = Style.foregroundColor
    }

    func update(oldProps: ArrowView.Props?, props: ArrowView.Props) {
        label.text = props.distance
    }
}
