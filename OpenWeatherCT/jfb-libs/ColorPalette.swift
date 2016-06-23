//
//  ColorPalette.swift
//  __core_sources
//
//  Created by verec on 24/10/2014.
//  Copyright (c) 2014 Cantabilabs Ltd. All rights reserved.
//

import Foundation
import UIKit

struct ColorBundle {
    let fore:UIColor
    let back:UIColor
}

protocol ColorProvider {
    func colorBundleForKey(key: String) -> ColorBundle
}

protocol IndexedPalette {
    func foreColor(index:Int) -> UIColor
}

class ColorPalette {

    static let jsonize:Bool     =   false

    private var colorsDict:     [String:UIColor] = [:]
    private var colorsArray:    [UIColor] = []

    var size: Int {
        get {
            return self.colorsArray.count
        }
    }

    subscript(index: Int) -> UIColor {
        return self.colorsArray[index]
    }

    subscript(key: String) -> UIColor? {
        return self.colorsDict[key]
    }

    func resourcePath(name: String) -> String {
        let root:String = NSBundle.mainBundle().bundlePath.NS.stringByAppendingPathComponent("settings")
        return root.NS.stringByAppendingPathComponent(name).NS.stringByAppendingPathExtension("sexp")!
    }

    init?(resource: String) {

        func parse(node: SExp) -> (String, UIColor)  {
            let name:String     = node.token
            let rgba:[String]   = (node.attributes as NSArray as! [String])
            let conv:[CGFloat]  = rgba.map {
                (s:String) in
                return CGFloat(s.NS.doubleValue)
            }
            return (name, UIColor(red: conv[0], green: conv[1], blue: conv[2], alpha: conv[3]))
        }

        let path = self.resourcePath(resource)

        guard let data = NSData(contentsOfFile: path) else {
            return nil
        }

        guard let root:SExp = SExpIO.decode(data) else {
            return nil
        }

        var cols:[String:UIColor] = [:]

        root[resource].each {

            (node:SExp!) in

            let (name, color) = parse(node)
            cols[name] = color
        }

        self.colorsDict = cols
        self.colorsArray = Array<UIColor>(cols.values) as [UIColor]

        if ColorPalette.jsonize {
            for key in self.colorsDict.keys {
                if let color = self.colorsDict[key] {
                    let hsb = color.hsb()
                    print(",\t\"\(key)\", [", terminator: "")
                    print("\(hsb.hue), \(hsb.saturation), \(hsb.brightness), \(hsb.alpha)" , terminator: "")
                    print("]")
                }
            }
        }
    }
}