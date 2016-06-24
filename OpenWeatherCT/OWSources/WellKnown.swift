//
//  WellKnown.swift
//  OpenWeatherCT
//
//  Created by verec on 23/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation

struct WellKnown {

    struct Network {
        static let weatherAPI   = OpenWeatherCT.Network()
        static let loader       = OpenWeatherCT.Loader()
    }

    struct Model {
        /// a value type, non mutable even though `currentForecast` can be
        /// made to refer to another "newer" immutable value type
        static var currentForecast: OpenWeatherCT.WeatherForecast? = .None
    }

    struct Controllers {
        static let forecastLoader = OpenWeatherCT.ForecastLoader()
    }
}