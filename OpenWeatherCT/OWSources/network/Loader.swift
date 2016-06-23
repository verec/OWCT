//
//  Loader.swift
//  OpenWeatherCT
//
//  Created by verec on 23/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation

struct Loader {

    struct Configuration : CustomDebugStringConvertible {
        let city:           String?
        let country:        String?
        let cityCode:       String?
        let latitude:       Double?
        let longitude:      Double?
        let lineCount:      Int?

        var debugDescription: String {
            /// work around "expression too complex ...
            let ci = "(city ?? \"<?city>\")"
            let co = "(country ?? \"<?country>\")"
            let cd = "(cityCode ?? \"<?cityCode>\")"
            let la = "(latitude ?? \"<?latitude>\")"
            let lo = "(longitude ?? \"<?longitude>\")"
            let lc = "(lineCount ?? \"<?lineCount>\")"

            return "\(ci), \(co), \(cd), \(la), \(lo), \(lc)"
        }

        init(
            city:           String? = .None
        ,   country:        String? = .None
        ,   cityCode:       String? = .None
        ,   latitude:       Double? = .None
        ,   longitude:      Double? = .None
        ,   lineCount:      Int?    = .None
            ) {

            self.city = city
            self.country = country
            self.cityCode = cityCode
            self.latitude = latitude
            self.longitude = longitude
            self.lineCount = lineCount
        }

        static func create(latitude latitude: Double, longitude:Double, recordCount:Int = 5) -> Configuration {
            return Configuration(latitude: latitude, longitude: longitude, lineCount: recordCount)
        }

        static func create(city city: String, country:String, recordCount:Int = 5) -> Configuration {
            return Configuration(city: city, country: country, lineCount: recordCount)
        }

        static func create(cityCode: String, recordCount:Int = 5) -> Configuration {
            return Configuration(cityCode: cityCode, lineCount: recordCount)
        }
    }

    typealias MainThreadCompletion = ([WeatherRecord]?)->()

    func load(configuration: Configuration, uiCompletion:MainThreadCompletion) {

        /// first part is "faat enought" to perform on the calling thread

        func callCompletion(records: [WeatherRecord]? = .None) {
            GCD.MainQueue.async {
                uiCompletion(records)
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

            if let data = data {
                /// JSON decoding is fast enough
                do {
                    if let result = try NSJSONSerialization.JSONObjectWithData(data, options: [.MutableContainers, .AllowFragments]) as? [String:AnyObject] {
                        let records = WeatherRecord.decode(result)
                        callCompletion(records)
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
}