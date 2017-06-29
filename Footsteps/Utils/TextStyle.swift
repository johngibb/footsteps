//
//  TextStyle.swift
//  Footsteps
//
//  Created by John Gibb on 6/28/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import Foundation
import UIKit

struct TextStyle {
    let fontName: String?
    let fontSize: CGFloat?
    let color: UIColor?
}

extension String {
    func with(style: TextStyle) -> NSAttributedString {
        var attributes = [String: Any]()

        attributes[NSFontAttributeName] = style.fontName.map({UIFont(name: $0, size: style.fontSize ?? UIFont.systemFontSize)})
            ?? UIFont.systemFont(ofSize: style.fontSize ?? UIFont.systemFontSize)

        if let color = style.color {
            attributes[NSForegroundColorAttributeName] = color
        }

        return NSAttributedString(string: self, attributes: attributes)
    }
}


