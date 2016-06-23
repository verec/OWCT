//
//  Colors.swift
//  OpenWeatherCT
//
//  Created by verec on 23/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation
import UIKit

struct Colors {

    private struct Primitives {
        static let palette                  =   ColorPalette(resource: "crayola")!

        static let cerulean                 =   palette["Cerulean"]!
        static let white                    =   UIColor.whiteColor()
        static let white95                  =   white.colorWithAlphaComponent(0.95)
        static let white90                  =   white.colorWithAlphaComponent(0.90)
        static let white80                  =   white.colorWithAlphaComponent(0.80)
    }

    struct Main {
        static let topViewBackgroundColor   =   Primitives.cerulean
    }

    static let themeColor                   =   Primitives.cerulean
    static let themeColor2                  =   UIColor.orangeColor()
}