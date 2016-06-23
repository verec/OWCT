//
//  Double.swift
//  __core_sources
//
//  Created by verec on 10/01/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation

extension Double {
    static func random() -> Double {
        return drand48()
    }
    static func arc4random_seed() {
        srand48(Int(1 + (arc4random() & 0x3fffffff)))
    }
}
