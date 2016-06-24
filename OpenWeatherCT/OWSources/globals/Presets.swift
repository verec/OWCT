//
//  Presets.swift
//  OpenWeatherCT
//
//  Created by verec on 24/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation

/*

 From the country list at: http://bulk.openweathermap.org/sample/city.list.json.gz

 {"_id":2643741,"name":"City of London","country":"GB","coord":{"lon":-0.09184,"lat":51.512791}}
 {"_id":6455259,"name":"Paris","country":"FR","coord":{"lon":2.35236,"lat":48.856461}}

 */

struct Presets {

    struct City {
        let name:       String
        let country:    String
        let code:       String
    }

    static let paris    = City(name: "Paris", country: "FR", code: "6455259")
    static let london   = City(name: "London", country: "GB", code: "2643741")

    static let presets  = [
        paris.name:     paris.code
    ,   london.name:    london.code
    ]
}