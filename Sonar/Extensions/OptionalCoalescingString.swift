//
//  OptionalCoalescingString.swift
//  Sonar
//
//  Created by NHSX on 23.04.20.
//  Copyright © 2020 NHSX. All rights reserved.
//

import Foundation

// via Ole Begemann: https://oleb.net/blog/2016/12/optionals-string-interpolation/

infix operator ???: NilCoalescingPrecedence

public func ???<T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    switch optional {
    case let value?: return String(describing: value)
    case nil: return defaultValue()
    }
}
