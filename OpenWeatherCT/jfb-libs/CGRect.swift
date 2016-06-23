//
//  CGRect.swift
//  __core_sources
//
//  Created by verec on 22/08/2015.
//  Copyright © 2015 Cantabilabs Ltd. All rights reserved.
//

import CoreGraphics
import UIKit.UIGeometry

enum CGRectPosition {
    case Above,Below
}

protocol CGSizeable {
    func autoSize() -> CGSize
}

/// Arbitratry positionning & Aligning
extension CGRect {

    func edgeAligned(toRect toRect:CGRect, edge: UIRectEdge) -> CGRect {

        var rect = self

        if [UIRectEdge.Top].contains(edge) {

            rect.origin.y = toRect.origin.y

        } else if [UIRectEdge.Left].contains(edge) {

            rect.origin.x = toRect.origin.x

        } else if [UIRectEdge.Bottom].contains(edge) {

            rect.origin.y = toRect.maxY - rect.height

        } else if [UIRectEdge.Right].contains(edge) {

            rect.origin.x = toRect.maxX - rect.width
        }
        
        return rect
    }

    func positionned(intoRect r: CGRect, widthUnitRange wu: CGFloat, heightUnitRange hu: CGFloat) -> CGRect {

        let size:CGSize        = r.size
        let center:CGPoint     = CGPoint(x: r.minX + size.width * wu
                                    ,    y: r.minY + size.height * hu)
        var rect = self
        rect.origin.x = center.x - (rect.width / 2.0)
        rect.origin.y = center.y - (rect.height / 2.0)

        return rect
    }
}

/// edge operations
extension CGRect {

    func edge(edge:UIRectEdge, alignedToRect:CGRect) -> CGRect {
        return edgeAligned(toRect: alignedToRect, edge: edge)
    }

    func edge(edge:UIRectEdge, ofSize: CGFloat) -> CGRect {
        return band(edge, size: ofSize)
    }

    func edge(edge: UIRectEdge, growBy: CGFloat) -> CGRect {
        return grow(edge, by: growBy)
    }

    func edge(edge: UIRectEdge, shrinkBy: CGFloat) -> CGRect {
        return shrink(edge, by: shrinkBy)
    }
    
    func edge(edge:UIRectEdge, offsetBy: CGFloat) -> CGRect {
        return offset(edge, by: offsetBy)
    }

    func edge(edge:UIRectEdge, abutToRect: CGRect) -> CGRect {
        var rect = self

        if edge == .Top {
            rect.origin.y = abutToRect.maxY
        } else if edge == .Left {
            rect.origin.x = abutToRect.maxX
        } else if edge == .Bottom {
            rect.origin.y = abutToRect.minY - abutToRect.height
        } else if edge == .Right {
            rect.origin.x = abutToRect.minX - abutToRect.width
        }

        return rect
    }
}

/// Centering
extension CGRect {

    func centered(intoRect intoRect: CGRect) -> CGRect {
        return self.positionned(intoRect: intoRect, widthUnitRange: 0.5, heightUnitRange: 0.5)
    }

    func centered(witdh: CGFloat, height: CGFloat) -> CGRect {
        /// workaround some Swift code gen bug that mistakes self.width &
        /// self.height with the width and height parameters ...

        var rect = CGRect.zero
        rect.size = CGSize(width: witdh, height: height)

        var orgn = self.center
        orgn.x -= rect.size.width / 2.0
        orgn.y -= rect.size.height / 2.0
        rect.origin = orgn

        return rect
    }

    func centered(side: CGFloat) -> CGRect {
        return self.centered(side, height: side)
    }

    func centeredPosition(position:CGPoint) -> CGRect {
        var rect = self

        rect.origin.x = position.x - rect.width / 2.0
        rect.origin.y = position.y - rect.height / 2.0

        return rect
    }

    func centeredXPosition(positionX:CGFloat) -> CGRect {
        var rect = self

        rect.origin.x = positionX - rect.width / 2.0

        return rect
    }

    func centeredYPosition(positionY:CGFloat) -> CGRect {
        var rect = self

        rect.origin.y = positionY - rect.height / 2.0

        return rect
    }

    func centerAttractor() -> CGRect {
        return self.squarest(.Shortest).centered(intoRect: self)
    }
}

/// Slicing
extension CGRect {

    func band(edge:UIRectEdge, size: CGFloat) -> CGRect {

        if [UIRectEdge.Top].contains(edge) {
            return self.top(size)
        } else if [UIRectEdge.Left].contains(edge) {
            return self.left(size)
        } else if [UIRectEdge.Bottom].contains(edge) {
            return self.bottom(size)
        } else if [UIRectEdge.Right].contains(edge) {
            return self.right(size)
        }

        return self
    }

    func top(offset: CGFloat, size: CGFloat) -> CGRect {
        var rect = self
        rect.origin.y = offset
        rect.size.height = size
        return rect
    }

    func top(size: CGFloat) -> CGRect {
        var rect = self
        rect.size.height = size
        return rect
    }

    func left(offset: CGFloat, size: CGFloat) -> CGRect {
        var rect = self
        rect.origin.x = offset
        rect.size.width = size
        return rect
    }

    func left(size: CGFloat) -> CGRect {
        var rect = self
        rect.size.width = size
        return rect
    }

    func bottom(offset: CGFloat, size: CGFloat) -> CGRect {
        var rect = self
        rect.origin.y = rect.size.height - (offset + size)
        rect.size.height = size
        return rect
    }

    func bottom(size: CGFloat) -> CGRect {
        var rect = self
        rect.origin.y += rect.size.height - size
        rect.size.height = size
        return rect
    }

    func right(offset: CGFloat, size: CGFloat) -> CGRect {
        var rect = self
        rect.origin.x = rect.size.width - (offset + size)
        rect.size.width = size
        return rect
    }

    func right(size: CGFloat) -> CGRect {
        var rect = self
        rect.origin.x += rect.size.width - size
        rect.size.width = size
        return rect
    }

    enum Aspect {
        case    Wide
        case    Tall
    }

    func slice(slice slice:Int, outOf:Int, aspect: Aspect) -> CGRect {
        var rect = self
        switch aspect {
            case    .Wide:  rect.size.height /= CGFloat(outOf)
                            rect.origin.y += rect.size.height * CGFloat(slice)
            case    .Tall:  rect.size.width /= CGFloat(outOf)
                            rect.origin.x += rect.size.width * CGFloat(slice)
        }
        return rect
    }

    func slices(sliceCount: Int, margin: CGFloat, aspect: Aspect) -> [CGRect] {

        var rects = [CGRect]()

        var rect = self
        let count = CGFloat(sliceCount)
        let gapCount = 1.0 + count
        let used = margin * gapCount

        switch aspect {

            case    .Wide:

                let remain = rect.size.height - used
                let size = remain / count

                rect.origin.y += margin
                rect.size.height = size

                for _ in 0 ..< sliceCount {
                    rects.append(rect)
                    rect.origin.y += margin + size
                }

            case    .Tall:

                let remain = rect.size.width - used
                let size = remain / count

                rect.origin.x += margin
                rect.size.width = size

                for _ in 0 ..< sliceCount {
                    rects.append(rect)
                    rect.origin.x += margin + size
                }
        }
        
        return rects
    }
}

/// Slicing
extension CGRect {

    func russianDolls(dollsCount: Int) -> [CGRect] {
        var rects : [CGRect] = [self]
        if dollsCount > 0 {
            let dollsGapCount = 1.0 + CGFloat(dollsCount)
            let (w,h) = (0.5 * self.width / dollsGapCount, 0.5 * self.height / dollsGapCount)
            for i in 1 ..< dollsCount {
                var rect = self

                let wBias = CGFloat(i) * w
                rect.origin.x += wBias
                rect.size.width -= 2.0 * wBias

                let hBias = CGFloat(i) * h
                rect.origin.y += hBias
                rect.size.height -= 2.0 * hBias

                rects.append(rect)
            }
        }
        
        return rects
    }
}

/// Slicing
extension CGRect {

    func spread(count:Int, margin: CGFloat, aspect: Aspect) -> [CGRect] {
        var rects = [CGRect]()
        let marginUsed = margin * CGFloat(1 + count)

        if aspect == .Wide {
            let remain = self.size.width - marginUsed
            let spreadWidth = remain / CGFloat(count)
            var sofar = margin
            for _ in 0 ..< count {
                var rect = self
                rect.origin.x = sofar
                rect.size.width = spreadWidth
                rects.append(rect)
                sofar = rect.maxX + margin
            }
        } else {
            let remain = self.size.height - marginUsed
            let spreadHeight = remain / CGFloat(count)
            var sofar = margin
            for _ in 0 ..< count {
                var rect = self
                rect.origin.y = sofar
                rect.size.height = spreadHeight
                rects.append(rect)
                sofar = rect.maxY + margin
            }
        }

        return rects
    }

    func spread(sizeables: [CGSizeable], aspect: Aspect) -> [CGRect] {

        if sizeables.count < 2 {
            return [self]
        }

        var rects: [CGRect] = sizeables.map {
            let size = $0.autoSize()
            var rect = self
            if aspect == .Wide {
                rect.size.height = size.height
            } else {
                rect.size.width = size.width
            }

            return rect.withWidth(rect.size.width).withHeight(rect.size.height)
        }

        let toKeep = rects.reduce(CGFloat(0.0)) {
            $0 + (aspect == .Wide ? $1.size.height : $1.size.width)
        }

        let toFill      = aspect == .Wide ? self.height : self.width
        let toDist      = toFill - toKeep
        let toSpread    = toDist / (CGFloat(rects.count) - 1.0)

        func wideSpread() {
            for index in 1 ..< rects.count {
                rects[index].origin.y = toSpread + rects[index-1].maxY
            }
        }

        func tallSpread() {
            for index in 1 ..< rects.count {
                rects[index].origin.x = toSpread + rects[index-1].maxX
            }
        }

        switch aspect {
            case    .Wide:  wideSpread()
            case    .Tall:  tallSpread()
        }

        return rects
    }

    func tabStops(stops: [CGFloat]) -> [CGRect] {

        return stops.map {
            let tab = $0
            let w = self.width
            let w1 = w * tab

            var rect = self
            rect.origin.x += w1
            rect.size.width -= w1
            return rect
        }
    }
}

/// Sizing
extension CGRect {

    func withWidth(forcedWidth:CGFloat) -> CGRect {
        var rect = self
        rect.size.width = forcedWidth
        return rect
    }

    func withX(forcedX:CGFloat) -> CGRect {
        var rect = self
        rect.origin.x = forcedX
        return rect
    }

    func withHeight(forcedHeight:CGFloat) -> CGRect {
        var rect = self
        rect.size.height = forcedHeight
        return rect
    }

    func withY(forcedY:CGFloat) -> CGRect {
        var rect = self
        rect.origin.y = forcedY
        return rect
    }

    func grow(edge:UIRectEdge, by: CGFloat) -> CGRect {

        var rect = self

        if edge == .Top {
            rect.origin.y -= by
            rect.size.height += by
        } else if edge == .Left {
            rect.origin.x -= by
            rect.size.width += by
        } else if edge == .Bottom {
            rect.size.height += by
        } else if edge == .Right {
            rect.size.width += by
        }

        return rect
    }

    func shrink(edge:UIRectEdge, by: CGFloat) -> CGRect {
        return self.grow(edge, by: -1.0 * by)
    }

    enum Sizest {   /// yeah, play with English a bit
        case    Shortest
        case    Tallest
    }

    func squarest(sizest: Sizest) -> CGRect {
        var rect = self
        let min = rect.width < rect.height ? rect.width : rect.height
        let max = rect.width > rect.height ? rect.width : rect.height
        let dim = sizest == .Shortest ? min : max
        rect.size.width = dim
        rect.size.height = dim
        return rect
    }

    func square(side: CGFloat) -> CGRect {
        return size(CGSize(width: side, height: side))
    }

    func size(size: CGSize) -> CGRect {
        var rect = self
        rect.size = size
        return rect
    }
}

/// Misc
extension CGRect {

    func offset(edge:UIRectEdge, by: CGFloat) -> CGRect {
        var rect = self
        if edge == .Left {
            rect.origin.x -= by
        } else if edge == .Right {
            rect.origin.x += by
        } else if edge == .Bottom {
            rect.origin.y -= by
        } else if edge == .Top {
            rect.origin.y += by
        }
        return rect
    }

    func rectByApplyingInsets(insets: UIEdgeInsets) -> CGRect {
        var rect = self
        rect.origin.x += insets.left
        rect.size.width -= insets.left + insets.right
        rect.origin.y += insets.top
        rect.size.height -= insets.top + insets.bottom
        return rect
    }

    func rowInBetween(other: CGRect) -> CGRect {
        var rect = self
        rect.size.height = other.minY - rect.maxY
        rect.origin.y = self.maxY
        return rect
    }

    var isDefined: Bool {
        if self.isEmpty || self.isInfinite || self.isNull {
            return false
        }
        return true
    }

    func swapOrientation() -> CGRect {
        var rect = self
        let w = rect.size.width
        rect.size.width = rect.size.height
        rect.size.height = w
        return rect
    }
    
    func stack(location:CGRectPosition, toRect:CGRect, offset:CGFloat=0) -> CGRect {
        
        var positioned = self
        
        switch location {
            
        case .Above:
            positioned.origin.y = toRect.origin.y - positioned.size.height
            positioned = positioned.offset(.Bottom, by: -offset)
        case .Below:
            positioned.origin.y = toRect.origin.y + toRect.size.height
            positioned = positioned.offset(.Top, by: offset)
        }
        
        return positioned
    }
}

/// Interesting points
extension CGRect {

    func north() -> CGPoint {       return CGPoint(x:self.midX, y:self.minY)    }
    func northEast() -> CGPoint {   return CGPoint(x:self.maxX, y:self.minY)    }
    func east() -> CGPoint {        return CGPoint(x:self.maxX, y:self.midY)    }
    func southEast() -> CGPoint {   return CGPoint(x:self.maxX, y:self.maxY)    }
    func south() -> CGPoint {       return CGPoint(x:self.midX, y:self.maxY)    }
    func southWest() -> CGPoint {   return CGPoint(x:self.minX, y:self.maxY)    }
    func west() -> CGPoint {        return CGPoint(x:self.minX, y:self.midY)    }
    func northWest() -> CGPoint {   return CGPoint(x:self.minX, y:self.minY)    }

    var N:  CGPoint     {   return north()      }
    var NE: CGPoint     {   return northEast()  }
    var E:  CGPoint     {   return east()       }
    var SE: CGPoint     {   return southEast()  }
    var S:  CGPoint     {   return south()      }
    var SW: CGPoint     {   return southWest()  }
    var W:  CGPoint     {   return west()       }
    var NW: CGPoint     {   return northWest()  }

    var topLeft:CGPoint     {   return NW       }
    var topRight:CGPoint    {   return NE       }
    var bottomLeft:CGPoint  {   return SW       }
    var bottomRight:CGPoint {   return SE       }

    var home: CGRect {
        var rect = self
        rect.origin = CGPoint.zero
        return rect
    }

    var center:CGPoint {
        return CGPoint(x: self.midX, y:self.midY)
    }
}
