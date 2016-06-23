//
//  WeatherRecord.swift
//  OpenWeatherCT
//
//  Created by verec on 23/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation

struct WeatherRecord {

    static func decode(jsonDict: [String:AnyObject]) -> [WeatherRecord]? {

        for (key, value) in jsonDict {
            print("\(key), value: \(value)")
        }
        return .None
    }

}