//
//  ComponentView.swift
//  Footsteps
//
//  Created by John Gibb on 6/23/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import Foundation

// Helpers around associated objects.
private let get = objc_getAssociatedObject, set = objc_setAssociatedObject
private struct Fields {
    static var isUpdateNeeded = 0
    static var state = 0
    static var oldProps = 0
    static var props = 0
}

protocol StatelessComponent: AnyObject {
    associatedtype Props
    func willUpdateProps(newProps: Props?)
    func update(oldProps: Props?, props: Props)
}

extension StatelessComponent {
    private var isUpdateNeeded: Bool {
        get { return get(self, &Fields.isUpdateNeeded) as? Bool ?? false }
        set { set(self, &Fields.isUpdateNeeded, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var oldProps: Props? {
        get { return get(self, &Fields.oldProps) as? Props }
        set { set(self, &Fields.oldProps, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    var props: Props? {
        get { return get(self, &Fields.props) as? Props }
        set {
            isUpdateNeeded = true
            willUpdateProps(newProps: newValue)
            isUpdateNeeded = false
            set(self, &Fields.props, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsUpdate()
        }
    }

    func setNeedsUpdate() {
        if isUpdateNeeded {
            return
        }
        isUpdateNeeded = true
        // delay(0, updateIfNeeded)
        updateIfNeeded()
    }

    func updateIfNeeded() {
        if isUpdateNeeded {
            if let props = props {
                update(oldProps: oldProps, props: props)
            }
            oldProps = props
            isUpdateNeeded = false
        }
    }

    // default implementation does nothing
    func willUpdateProps(newProps: Props?) {}
}

protocol Component: StatelessComponent {
    associatedtype State
    func getInitialState() -> State
}

extension Component {
    var state: State {
        get {
            // Lazily initialize using getInitialState if null.
            return get(self, &Fields.state) as? State ?? {
                let state = getInitialState()
                set(self, &Fields.state, state, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return state
                }()
        }
        set {
            set(self, &Fields.state, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsUpdate()
        }
    }
}
