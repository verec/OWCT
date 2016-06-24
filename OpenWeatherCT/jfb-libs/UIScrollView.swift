//
//  UIScrollView.swift
//  WordBuzz
//
//  Created by verec on 10/04/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation
import UIKit

/// lifted from WordBuzz on 10 Apr 2016
extension UIScrollView {

    func snapToIntegerRowForProposedContentOffset(targetContentOffset: CGPoint, rowHeight: CGFloat) -> CGPoint {
        let dest = targetContentOffset
        let high = self.bounds.size.height
        let span = self.contentSize.height - high
        let oneRow = rowHeight
        let halfRow = oneRow / 2.0
        var row = floor(dest.y / oneRow)
        let rem = dest.y - row * oneRow
        if rem > halfRow {
            row += 1.0
        }
        var target = row * oneRow
        if target > span {
            target = span
        }
        return CGPoint(x: dest.x, y: target)
    }
}
