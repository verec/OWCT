//
//  UIView.swift
//  __core_sources
//
//  Created by verec on 05/09/2015.
//  Copyright © 2015 Cantabilabs Ltd. All rights reserved.
//

import Swift

import Foundation
import UIKit

//extension UIView : CGSizeable {
//    func autoSize() -> CGSize {
//        if let superview = self.superview {
//            let b = superview.bounds
//            var size = b.size
//            self.sizeToFit()
//            size.width = min(self.bounds.width, b.size.width)
//            self.bounds.size = self.sizeThatFits(size)
//        } else {
//            self.sizeToFit()
//        }
//        return self.bounds.size
//    }
//}

extension UIView {

    enum HomeButtonLocation : String {

        case    Top
        case    Left
        case    Bottom
        case    Right
        case    Other

        init(deviceOrientation: UIDeviceOrientation) {
            switch deviceOrientation {
                case    .Unknown:               self = Other
                case    .Portrait:              self = Bottom
                case    .PortraitUpsideDown:    self = Top
                case    .LandscapeLeft:         self = Right
                case    .LandscapeRight:        self = Left
                case    .FaceUp:                self = Other
                case    .FaceDown:              self = Other
            }
        }
    }

//    /// http://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
//    /// http://www.iphoneresolution.com
//    struct DevicePointSize {
//        static let size0    =   CGSize(width: 320.0, height: 480.0)
//        static let size1    =   CGSize(width: 320.0, height: 568.0)
//        static let size2    =   CGSize(width: 375.0, height: 667.0)
//        static let size3    =   CGSize(width: 414.0, height: 736.0)
//    }

//    struct Environment {
//
//        let size: CGSize
//        let orin: UIDeviceOrientation
//        let iPad: Bool
//        let hReg: Bool
//        let vReg: Bool
//        let land: Bool
//        let scrn: UIScreen
//        let home: HomeButtonLocation
//
//        init(view: UIView) {
//            size = view.bounds.size
//            iPad = view.window?.traitCollection.userInterfaceIdiom == .Pad
//            hReg = view.window?.traitCollection.horizontalSizeClass == .Regular
//            vReg = view.window?.traitCollection.verticalSizeClass == .Regular
//            orin = UIDevice.currentDevice().orientation
//            land = UIDeviceOrientationIsLandscape(orin)
//            scrn = UIScreen.mainScreen()
//            home = HomeButtonLocation(deviceOrientation: orin)
//        }
//
//        var description: String {
//            let iThg = iPad ? "iPad" : "iPhone"
//            let hR   = hReg ? "HR" : "HC"
//            let vR   = vReg ? "VR" : "VC"
//            let ornt = land ? "Land" : "Port"
//            let scle = Int(scrn.scale)
//            let ntsc = Int(scrn.nativeScale)
//            let ntsz = scrn.nativeBounds.size
//            let szwd = Int(size.width)
//            let szht = Int(size.height)
//            let nzwd = Int(ntsz.width)
//            let nzht = Int(ntsz.height)
//
//            return "\(iThg)@\(scle)x – \(szwd):\(szht) (\(nzwd):\(nzht)@\(ntsc)x) [\(hR)-\(vR)] – \(ornt) – Home@\(home)"
//        }
//    }

//    func environement() -> Environment {
//        return Environment(view: self)
//    }
}

extension UIView {

    func dismissKeyboard() {

        func doDismiss(fromView: UIView) {
            fromView.endEditing(true)
        }

        for window in UIApplication.sharedApplication().windows {
            doDismiss(window)
        }
    }
}

extension UIView {

    func forceLayout() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    func deepSetNeedsLayout() {
        self.setNeedsLayout()
        for view in self.subviews {
            view.deepSetNeedsLayout()
        }
    }

    func forceTintColorAllTheWayDownStartingWithView(view: UIView, tintColor: UIColor) {
        view.tintColor = tintColor
        for v in view.subviews {
            if v is UIImageView {
                let imageView = v as! UIImageView
                if let image = imageView.image where imageView.tag != 1357111317 {
                    imageView.image = image.imageWithRenderingMode(.AlwaysTemplate)
                }
            }
            forceTintColorAllTheWayDownStartingWithView(v, tintColor:tintColor)
        }
    }

    func digFirstImageView(view: UIView) -> UIImageView? {
        if view is UIImageView {
            return (view as! UIImageView)
        }

        for v in view.subviews {
            if let imageView = digFirstImageView(v) {
                return imageView
            }
        }

        return .None
    }
}

extension UIView {
    var origin:CGPoint {
        var o = self.frame.topLeft
        if !(self is UIWindow) {
            if let s = self.superview {
                let k = s.origin
                o.x += k.x
                o.y += k.y
            }
        }
        return o
    }
}

extension UIView {

    var orphaned:Bool {
        return self.superview == nil
    }

    func snpashot() -> UIImage {
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, scale)
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    typealias PostOverlay = (CGContextRef) -> ()

    func layerSnpashot(postEffect:Bool = true, customEffect:PostOverlay? = .None) -> UIImage {
        /// FIXME: use scale rather than 0 -> 6+/6S+ ... ???
        let scale = UIScreen.mainScreen().scale

        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)

        if let context = UIGraphicsGetCurrentContext() {
            if postEffect {
                self.layer.renderInContext(context)
                if  let customEffect = customEffect {
                    customEffect(context)
                }
            } else {
                if  let customEffect = customEffect {
                    customEffect(context)
                }
                self.layer.renderInContext(context)
            }
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
