//
//  Tap.swift
//  Footsteps
//
//  Created by John Gibb on 6/28/17.
//  Copyright © 2017 John Gibb. All rights reserved.
//

import Foundation

protocol Tap {}

extension Tap {
    @discardableResult func tap( _ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Tap {}
