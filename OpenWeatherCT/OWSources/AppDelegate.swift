//
//  AppDelegate.swift
//  OpenWeatherCT
//
//  Created by verec on 23/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        self.window = Top.mainWindow {
            Top.defaultController.orientation = [
                .Portrait,.PortraitUpsideDown
            ]

            Top.defaultController.statusBarStyle = .LightContent
            Top.mainView = TopView()
        }
        self.window?.backgroundColor = UIColor.whiteColor()

        /// this primes the app with Paris. Normally I'd read the userdefaults
        /// and restore last user choice instead.
        if let parisCode = Presets.presets[Presets.paris.name] {
            WellKnown.Controllers.forecastLoader.load(parisCode)
        }

        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("openURL:options")
        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        print("applicationDidBecomeActive")
    }

    func applicationWillResignActive(application: UIApplication) {
        print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        print("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        print("applicationWillEnterForeground")
    }

    func applicationWillTerminate(application: UIApplication) {
        print("applicationWillEnterForeground")
    }
}

