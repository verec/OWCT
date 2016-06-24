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

            Top.defaultController.statusBarStyle = .Default
            Top.mainView = TopView()
        }

        self.window?.backgroundColor = UIColor.whiteColor()

        /////// tests
//        WellKnown.Network.weatherAPI.load() {
//            (error, data) in
//
//            if let data = data {
//                /// doo-da JSON parsing
//                print(data)
//            } else if let error = error {
//                /// doo-da error handling
//                print(error)
//            }
//        }

//        let configuration = Configuration.create(city: "London", country: "uk", recordCount: 5)
        let configuration = Configuration.create(city: "London", country: "uk")
        WellKnown.Network.loader.load(configuration) {
            (forecast: WeatherForecast?) in

            WellKnown.Model.currentForecast = forecast
            /// on main thread

        }
//        WellKnown.wireboard.rewire()

        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("openURL:options")
        return true
    }


    func applicationDidBecomeActive(application: UIApplication) {
        print("applicationDidBecomeActive")
//        queryCL()
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

