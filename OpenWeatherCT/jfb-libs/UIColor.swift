//
//  UIColor.swift
//  __core_sources
//
//  Created by verec on 28/12/2015.
//  Copyright © 2015 Cantabilabs Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    func between(otherColor: UIColor, unitRange: Math.UnitRange) -> UIColor {
        let (h1,s1,b1,a1) = self.hsb()
        let (h2,s2,b2,a2) = otherColor.hsb()

        func at(low: CGFloat, high: CGFloat, unitRange: Math.UnitRange) -> CGFloat {
            return low + (high - low) * unitRange
        }

        return UIColor(
            hue:        at(h1, high: h2, unitRange: unitRange)
        ,   saturation: at(s1, high: s2, unitRange: unitRange)
        ,   brightness: at(b1, high: b2, unitRange: unitRange)
        ,   alpha:      at(a1, high: a2, unitRange: unitRange))
    }
}

extension UIColor {

    typealias Components = (hue:CGFloat, saturation:CGFloat, brightness:CGFloat, alpha:CGFloat)

    func hsb() -> Components {
        var hue:CGFloat = 0.0
        var sat:CGFloat = 0.0
        var bri:CGFloat = 0.0
        var alp:CGFloat = 0.0

        self.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alp)

        return (hue:hue, saturation:sat, brightness:bri, alpha:alp)
    }

    func colorWithBrightness(brightness: CGFloat) -> UIColor {
        var hue:CGFloat = 0.0
        var sat:CGFloat = 0.0
        var bri:CGFloat = 0.0
        var alp:CGFloat = 0.0

        self.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alp)

        return UIColor(hue: hue, saturation: sat, brightness: brightness, alpha: alp)
    }
    
    func colorWithSaturation(saturation: CGFloat) -> UIColor {
        var hue:CGFloat = 0.0
        var sat:CGFloat = 0.0
        var bri:CGFloat = 0.0
        var alp:CGFloat = 0.0

        self.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alp)

        return UIColor(hue: hue, saturation: saturation, brightness: bri, alpha: alp)
    }
    
    func colorWithHue(hue h: CGFloat) -> UIColor {
        var hue:CGFloat = 0.0
        var sat:CGFloat = 0.0
        var bri:CGFloat = 0.0
        var alp:CGFloat = 0.0

        self.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alp)

        return UIColor(hue: h, saturation: sat, brightness: bri, alpha: alp)
    }

    func shadesToWhite(shades: Int, brighnessBias:Bool = true) -> [UIColor] {
        if shades < 2 {
            return [self]
        }
        var hue:CGFloat = 0.0
        var sat:CGFloat = 0.0
        var bri:CGFloat = 0.0
        var alp:CGFloat = 0.0

        self.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alp)

        var colors = [UIColor]()

        for index in 0 ..< shades {
            let sat =   CGFloat(1 + index) / CGFloat(1 + shades)
            let bri =   brighnessBias
                    ?   Math.clamp(sat*2.5, max: 1.0)
                    :   1.0

            let fColor = UIColor(hue:       hue
                            ,   saturation: 1.0 - sat
                            ,   brightness: bri
                            ,   alpha:      alp)
            colors.append(fColor)
        }
        return colors
    }


    func shadesToBlack(shades: Int) -> [UIColor] {
        if shades < 2 {
            return [self]
        }
        var hue:CGFloat = 0.0
        var sat:CGFloat = 0.0
        var bri:CGFloat = 0.0
        var alp:CGFloat = 0.0

        self.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alp)

        var colors = [UIColor]()

        for index in 0 ..< shades {
            let bri = CGFloat(1 + index) / CGFloat(1 + shades)

            let fColor = UIColor(hue:       hue
                            ,   saturation: 1.0
                            ,   brightness: 1.0 - bri
                            ,   alpha:      alp)
            colors.append(fColor)
        }
        return colors
    }

    class func RGB255(red:CGFloat, green:CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }

    class func hex6(value: Int) -> UIColor {
        return hex(value)
    }

    class func hex(value: Int) -> UIColor {

        let r = (value >> 16) & 0xff
        let g = (value >> 8) & 0xff
        let b = value & 0xff

        return RGB255(CGFloat(r), green:CGFloat(g), blue:CGFloat(b))
    }
}
