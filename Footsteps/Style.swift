//
//  Style.swift
//  Footsteps
//
//  Created by John Gibb on 6/23/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import Foundation
import UIKit

struct Style {
    // App-wide Style
    static let foregroundColor = UIColor(white: 0.56, alpha: 1)
    static let backgroundColor = UIColor(white: 0.29, alpha: 1)
    static let screenInsets = UIEdgeInsets(
        top: 20,
        left: 10,
        bottom: 10,
        right: 10
    )

    // Search Result Style
    static let resultBackgroundColor = UIColor.white
    static let resultBackgroundColorSelected = UIColor.lightGray
    static let searchToResultSpacing = CGFloat(8)
    static let betweenResultSpacing = CGFloat(5)
    static let resultInsets = UIEdgeInsets(
        top: 8,
        left: 8,
        bottom: 8,
        right: 8
    )
    static let resultNameStyle = TextStyle(fontName: nil, fontSize: nil, color: .black)
    static let resultAddressStyle = TextStyle(fontName: nil, fontSize: nil, color: foregroundColor)
}
