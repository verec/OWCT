//
//  Loader.swift
//  OpenWeatherCT
//
//  Created by verec on 23/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation
import UIKit

struct Loader {

    var iconCache = [String:UIImage]()

    typealias MainThreadCompletion = (WeatherForecast?)->()
    typealias MainThreadImageCompletion = (UIImage?)->()

    func load(configuration: Configuration, uiCompletion:MainThreadCompletion) {

        assert(NSThread.isMainThread())

        /// first part is "faat enought" to perform on the calling thread

        func callCompletion(forecast: WeatherForecast? = .None) {
            GCD.MainQueue.async {
                uiCompletion(forecast)
            }
        }
        /// infer the query mode from the configuration
        var dict = [String:String]()
        if let lat = configuration.latitude {
            /// that's a lat/lon query
            guard let lon = configuration.longitude else {
                callCompletion()
                return
            }
            dict["lat"] = "\(lat)"
            dict["lon"] = "\(lon)"
        } else if let cityCode = configuration.cityCode {
            /// that's a city id query
            dict["id"] = "\(cityCode)"
        } else if let city = configuration.city {
            /// that's a city by name query
            guard let country = configuration.country else {
                callCompletion()
                return
            }
            dict["q"] = "\(city),\(country)"
        } else {
            /// we don't know how to support the configuration
            print("not supported query configuration \(configuration)")
            callCompletion()
            return
        }

        /// the dictionary is valid at this point, add the optional record count
        if let recordCount = configuration.lineCount {
            dict["cnt"] = "\(recordCount)"
        }

        /// the network call happens on serail queue #1
        WellKnown.Network.weatherAPI.load(dict) {
            (error, data) in

            /// we're back on the main thread here.
            assert(NSThread.isMainThread())

            if let data = data {
                /// JSON decoding is fast enough
                do {
//                    print("data: \(data)")
                    if let result = try NSJSONSerialization.JSONObjectWithData(data, options: [.MutableContainers, .AllowFragments]) as? [String:AnyObject] {
                        let forecast = WeatherForecast.decode(result)
                        callCompletion(forecast)
                    }
                } catch {
                    print(error)
                    callCompletion()
                }

            } else if let error = error {
                print(error)
                callCompletion()
            }
        }
    }

    mutating func load(icon: String, uiCompletion:MainThreadImageCompletion) {

        func callCompletion(records: UIImage? = .None) {
            GCD.MainQueue.async {
                uiCompletion(records)
            }
        }

        assert(NSThread.isMainThread())

        if let image = self.iconCache[icon] {
            callCompletion(image)
            return
        }

        /// the network call happens on serail queue #1
        WellKnown.Network.weatherAPI.load(icon) {
            (error, data) in

            /// we're back on the main thread here.
            assert(NSThread.isMainThread())

            if let data = data {
                /// we use UIKit here so try and be safe: use the main thread
                /// for image creation
                if let image = UIImage(data: data) {
                    self.iconCache[icon] = image
                    callCompletion(image)
                }

            } else if let error = error {
                print(error)
                callCompletion()
            }
        }
    }
}