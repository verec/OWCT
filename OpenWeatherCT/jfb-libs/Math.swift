//
//  Math.swift
//  __core_sources
//
//  Created by verec on 25/12/2015.
//  Copyright © 2015 Cantabilabs Ltd. All rights reserved.
//

import Foundation
import CoreGraphics

struct Math {

    typealias Radian    = CGFloat
    typealias UnitValue = CGFloat   /// also see UnitRange
    typealias UnitRange = CGFloat   /// also see UnitValue

    struct Constants {
        static let π                = CGFloat(M_PI)
        static let πx2              = π * 2.0
        static let π_2              = π / 2.0
        static let πx3_2            = 3.0 * π / 2.0
        static let epsilon:CGFloat  = CGFloat(1e-3)
        static let ε:CGFloat        = CGFloat(1e-3)
    }

    static func discreetize(unitValue: CGFloat, range: Int) -> Int {
        let step = 1.0 / CGFloat(range)
        let value = unitValue / step
        return Int(value)
    }

    static func discreetize(unitValue: CGFloat, range: Int) -> CGFloat {
        let step = 1.0 / CGFloat(range)
        let value = unitValue / step
        return value
    }

    static func clip<T : Comparable>(val: T, min:T, max:T) -> T {
        if val < min {
            return min
        } else if val > max {
            return max
        }
        return val
    }

    static func clamp<T : Comparable>(val: T, max:T) -> T {
        return clip(val, min: val, max: max)
    }
}