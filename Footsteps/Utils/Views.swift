//
//  Views.swift
//  Footsteps
//
//  Created by John Gibb on 6/19/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /**
     Provides a convenient shorthand for adding a constraint.

     Used like: container.addConstraint(label, .Left, .Equal, button, .Right)
     */
    @discardableResult func addConstraint(_ view1: UIView, _ attr1: NSLayoutAttribute, _ relation: NSLayoutRelation, _ view2: UIView, _ attr2: NSLayoutAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: constant)
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = true
        return constraint
    }

    /**
     Provides a convenient shorthand for adding a constraint.

     Used like: label.addConstraint(.Width, .Equal, 100)
     */
    @discardableResult func addConstraint(_ attr: NSLayoutAttribute, _ relation: NSLayoutRelation, _ constant: CGFloat, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: attr, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant)
        constraint.isActive = true
        if let priority = priority {
            constraint.priority = priority
        }
        return constraint
    }

    /**
     Adds a constraint for the specified size
     */
    func addSizeConstraint(_ size: CGSize, priority: UILayoutPriority? = nil) {
        addSizeConstraint(width: size.width, height: size.height, priority: priority)
    }

    /**
     Adds a constraint for non-nil values of width and height
     */
    func addSizeConstraint(width: CGFloat? = nil, height: CGFloat? = nil, priority: UILayoutPriority? = nil) {
        if let width = width {
            self.addConstraint(.width, .equal, width, priority: priority)
        }
        if let height = height {
            self.addConstraint(.height, .equal, height, priority: priority)
        }
    }

    /// Removes constraints affecting the external positioning of this
    /// view by removing and re-inserting it from its superview.
    func removeExternalConstraints() {
        if let superview = self.superview, let index = superview.subviews.index(of: self) {
            removeFromSuperview()
            superview.insertSubview(self, at: index)
        }
    }

    /// Adds a height constraint to maintain a given aspect ratio based on the natural width of the view.
    @discardableResult func constrainToAspectRatio(_ ratio: CGFloat, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        // width = height * ratio; height = width / ratio
        return addConstraint(self, .height, .equal, self, .width, multiplier: CGFloat(1) / ratio, priority: priority)
    }

    func fillWith(_ view: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        addSubviews(view)
        view.constrainToContainer(insets)
    }

    /**
     Adds a constraint to center this view inside of it's superview in the specified axes. If no
     axes are specified, it will be centered in both.
     */
    func pinToCenterOfContainer(vertically: Bool? = nil, horizontally: Bool? = nil) {
        if vertically == nil && horizontally == nil {
            return pinToCenterOfContainer(vertically: true, horizontally: true)
        }
        if let container = self.superview {
            if horizontally ?? false {
                container.addConstraint(self, .centerX, .equal, container, .centerX)
            }
            if vertically ?? false {
                container.addConstraint(self, .centerY, .equal, container, .centerY)
            }
        } else {
            print("Warning: Superview was nil. 'pinToCenterOfContainer' expects the view to be in a superview.")
        }
    }

    /**
     Adds the necessary autolayout constraints to make the view stay the same size
     as it's container view, less optional insets
     */
    func constrainToContainer(_ insets: UIEdgeInsets = UIEdgeInsets.zero) {
        pinToContainer(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
    }

    /**
     Adds the necessary autolayout constraints to pin the view to the specified edges of
     it's container. If the value for a side is null, that side won't be pinned. If all are nil,
     then all sides will be pinned
     */
    func pinToContainer(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil, respectMargins: Bool = false) {
        if top == nil && left == nil && bottom == nil && right == nil {
            pinToContainer(top: 0, left: 0, bottom: 0, right: 0, respectMargins: respectMargins)
            return
        }
        let leadingAttribute  = respectMargins ? NSLayoutAttribute.leadingMargin : NSLayoutAttribute.leading
        let trailingAttribute = respectMargins ? NSLayoutAttribute.trailingMargin : NSLayoutAttribute.trailing
        let topAttribute      = respectMargins ? NSLayoutAttribute.topMargin : NSLayoutAttribute.top
        let bottomAttribute   = respectMargins ? NSLayoutAttribute.bottomMargin : NSLayoutAttribute.bottom

        if let container = self.superview {
            self.translatesAutoresizingMaskIntoConstraints = false

            if let left = left {
                container.addConstraint(self, leadingAttribute, .equal, container, leadingAttribute, constant: left)
            }

            if let right = right {
                container.addConstraint(container, trailingAttribute, .equal, self, trailingAttribute, constant: right)
            }

            if let top = top {
                container.addConstraint(self, topAttribute, .equal, container, topAttribute, constant: top)
            }

            if let bottom = bottom {
                container.addConstraint(container, bottomAttribute, .equal, self, bottomAttribute, constant: bottom)
            }
        } else {
            print("Warning: Superview was nil. 'pinToContainer' expects the view to be in a superview.")
        }
    }

    func addSubviews(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }

    func removeSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }

    func reverseSubviews() {
        var lastIndex = subviews.count - 1
        var firstIndex = 0
        while lastIndex > firstIndex {
            exchangeSubview(at: lastIndex, withSubviewAt: firstIndex)
            lastIndex -= 1
            firstIndex += 1
        }
    }

    func firstParent<T: UIView>(type: T.Type) -> T? {
        var view = self
        while view.superview != nil {
            if let v = view.superview as? T {
                return v
            }
            view = view.superview!
        }
        return nil
    }
}

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: UILayoutConstraintAxis) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
    }
}
