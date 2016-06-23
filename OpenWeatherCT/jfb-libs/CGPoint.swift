//
//  CGPoint.swift
//  __core_sources
//
//  Created by verec on 02/12/2015.
//  Copyright © 2015 Cantabilabs Ltd. All rights reserved.
//

import CoreGraphics
import UIKit.UIGeometry

extension CGPoint {

    func parametric(r:Math.UnitValue, toPoint: CGPoint) -> CGPoint {

        func parametric(a: CGFloat, b:CGFloat, r:Math.UnitValue) -> CGFloat {
            return a * (1.0 - r) + b * r
        }

        return CGPoint(
            x: parametric(self.x, b: toPoint.x, r: r)
        ,   y: parametric(self.y, b: toPoint.y, r: r))
    }

    func centeredSquare(size: CGFloat) -> CGRect {
        var rect = CGRect.zero.size(CGSize(width: size, height: size))
        rect.origin.x = self.x - size / 2.0
        rect.origin.y = self.y - size / 2.0
        return rect
    }
}