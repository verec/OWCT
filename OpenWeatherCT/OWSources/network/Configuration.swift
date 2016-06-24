//
//  Configuration.swift
//  OpenWeatherCT
//
//  Created by verec on 24/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation

struct Configuration : CustomDebugStringConvertible {

    let city:           String?
    let country:        String?
    let cityCode:       String?
    let latitude:       Double?
    let longitude:      Double?
    let lineCount:      Int?

    var debugDescription: String {
        /// work around "expression too complex ...
        let ci = "\(city)"
        let co = "\(country)"
        let cd = "\(cityCode)"
        let la = "\(latitude)"
        let lo = "\(longitude)"
        let lc = "\(lineCount)"

        return "\(ci), \(co), \(cd), \(la), \(lo), \(lc)"
    }

    init(
        city:           String? = .None
    ,   country:        String? = .None
    ,   cityCode:       String? = .None
    ,   latitude:       Double? = .None
    ,   longitude:      Double? = .None
    ,   lineCount:      Int?    = .None) {

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

    static func create(city city: String, country:String, recordCount:Int? = .None) -> Configuration {
        return Configuration(city: city, country: country, lineCount: recordCount)
    }

    static func create(cityCode: String, recordCount:Int = 5) -> Configuration {
        return Configuration(cityCode: cityCode, lineCount: recordCount)
    }
}

