//
//  Top.swift
//  __core_sources
//
//  Created by verec on 31/10/2015.
//  Copyright © 2015 Cantabilabs Ltd. All rights reserved.
//

import Foundation
import UIKit

struct Top {

    class DefaultWindow :UIWindow {
        override func layoutSubviews() {
            super.layoutSubviews()

            Top.mainView.frame = self.bounds
        }
    }

    class DefaultView :UIView {
        override func layoutSubviews() {
            super.layoutSubviews()

            for view in self.subviews {
                view.frame = self.bounds
            }
        }
    }

    class DefaultController : UIViewController {

        var orientation: UIInterfaceOrientationMask = [.All]
        var statusBarHidden:Bool = false
        var statusBarStyle:UIStatusBarStyle = .Default

        override func shouldAutorotate() -> Bool {
            return true
        }

        override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
            return orientation
        }

        override func prefersStatusBarHidden() -> Bool {
            return statusBarHidden
        }
        
        override func preferredStatusBarStyle() -> UIStatusBarStyle {
            return statusBarStyle
        }
    }

    static var defaultView:UIView       =   DefaultView()

    static var mainView                 =   defaultView
    static let defaultWindow            =   DefaultWindow(frame: UIScreen.mainScreen().bounds)
    static let defaultController        =   DefaultController()

    static func mainWindow(@noescape lamda:()->()) -> UIWindow {

        lamda()

        /// This creates a default blank view that is fullscreen and supports
        /// all four orientations
        Top.defaultWindow.rootViewController = Top.defaultController
        Top.defaultController.view = Top.mainView
        Top.defaultWindow.makeKeyAndVisible()

        return Top.defaultWindow
    }
}

