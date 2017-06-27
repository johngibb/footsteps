//
//  Event.swift
//  Footsteps
//
//  Created by John Gibb on 6/27/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import Foundation

struct Subscription<T> {
    fileprivate weak var observer: AnyObject?
    fileprivate let callback: ((T) -> Void)
    var active: Bool
}

class Event<T> {
    private var listeners = [Subscription<T>]()

    /// Subscribes the given callback to the event.
    @discardableResult func subscribe(on observer: AnyObject, _ callback: @escaping ((T) -> Void)) -> Subscription<T> {
        let listener = Subscription(observer: observer, callback: callback, active: true)
        listeners.append(listener)
        return listener
    }


    /// Subscribes the given member function to the event, without
    /// retaining self.
    @discardableResult func subscribe<U: AnyObject>(on observer: U, _ callback: @escaping ((U) -> (T) -> Void)) -> Subscription<T> {
        return subscribe(on: observer) {[weak observer] t in
            guard let observer = observer else { return }
            callback(observer)(t)
        }
    }

    /// Emits an event with the given payload.
    func emit(_ payload: T) {
        for listener in listeners {
            if listener.observer != nil && listener.active {
                listener.callback(payload)
            }
        }
        purge()
    }

    /// Removes deallocated listeners.
    private func purge() {
        for listener in listeners {
            if listener.observer == nil {
                listeners = listeners.filter({$0.observer != nil})
                return
            }
        }
    }
}
