//
//  ForecastLoader.swift
//  OpenWeatherCT
//
//  Created by verec on 24/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation
import UIKit

struct ForecastLoader {

    func applyForecast(forecast: WeatherForecast?) {
        if let forecast = forecast {
            WellKnown.Model.currentForecast = forecast
            Views.Main.forecastView.reload()
        }
    }

    func load(cityCode:String) {
        let configuration = Configuration.create(cityCode)
        WellKnown.Network.loader.load(configuration) { self.applyForecast($0) }
    }

    func load(city: String, country: String) {
        let configuration = Configuration.create(city: city, country: country)
        WellKnown.Network.loader.load(configuration) { self.applyForecast($0) }
    }
}