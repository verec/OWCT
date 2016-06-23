//
//  Int.swift
//  __core_sources
//
//  Created by verec on 10/01/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation

extension Int {

    struct Cache {
        static var seed:Int? = .None
    }

    static func resetRandom() {
        Int.Cache.seed = 0
    }

    static func random() -> Int {
        return Int(arc4random())
    }

    static func random(range: Range<Int>) -> Int {
        return Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex))) + range.startIndex
    }

    static func random(range: Int) -> Int {
        if let seed = Int.Cache.seed {
            Int.Cache.seed = seed + 1
            return seed % range
        }
        return Int(arc4random_uniform(UInt32(range)))
    }
}
