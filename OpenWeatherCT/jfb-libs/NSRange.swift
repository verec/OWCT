//
//  NSRange.swift
//  __core_sources
//
//  Created by verec on 10/01/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation

extension NSRange {

    var minOffset:Int {
        return self.location
    }

    var maxOffset: Int {
        return self.location + self.length
    }

    var onePast: Int {
        return 1 + maxOffset
    }

    var undefined: Bool {
        return self.location == NSNotFound
    }
}
