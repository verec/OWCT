//
//  WeatherRecord.swift
//  OpenWeatherCT
//
//  Created by verec on 23/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation

/*
 |   {
 |     "city": {
 |       "id": 2643743,
 |       "name": "London",
 |       "coord": {
 |         "lon": -0.12574,
 |         "lat": 51.50853
 |       },
 |       "country": "GB",
 |       "population": 0,
 |       "sys": {
 |         "population": 0
 |       }
 |     },
 |     "cod": "200",
 |     "message": 0.0035,
 |     "cnt": 5,
 |     "list": [
 |       {
 |         "dt": 1466726400,
 |         "main": {
 |           "temp": 15.44,
 |           "temp_min": 13.71,
 |           "temp_max": 15.44,
 |           "pressure": 1020.71,
 |           "sea_level": 1030.65,
 |           "grnd_level": 1020.71,
 |           "humidity": 92,
 |           "temp_kf": 1.73
 |         },
 |         "weather": [
 |           {
 |             "id": 801,
 |             "main": "Clouds",
 |             "description": "few clouds",
 |             "icon": "02n"
 |           }
 |         ],
 |         "clouds": {
 |           "all": 12
 |         },
 |         "wind": {
 |           "speed": 3.51,
 |           "deg": 252.502
 |         },
 |         "rain": {
 |
 |         },
 |         "sys": {
 |           "pod": "n"
 |         },
 |         "dt_txt": "2016-06-24 00:00:00"
 |       },
 |       {
 |         "dt": 1466737200,
 |         "main": {
 |           "temp": 14.29,
 |           "temp_min": 12.64,
 |           "temp_max": 14.29,
 |           "pressure": 1031.27,
 |           "sea_level": 1031.27,
 |           "grnd_level": 1031.27,
 |           "humidity": 94,
 |           "temp_kf": 1.64
 |         },
 |         "weather": [
 |           {
 |             "id": 804,
 |             "main": "Clouds",
 |             "description": "overcast clouds",
 |             "icon": "04n"
 |           }
 |         ],
 |         "clouds": {
 |           "all": 92
 |         },
 |         "wind": {
 |           "speed": 3.26,
 |           "deg": 271.505
 |         },
 |         "rain": {
 |
 |         },
 |         "sys": {
 |           "pod": "n"
 |         },
 |         "dt_txt": "2016-06-24 03:00:00"
 |       },
 |       {
 |         "dt": 1466769600,
 |         "main": {
 |           "temp": 19.43,
 |           "temp_min": 17.88,
 |           "temp_max": 19.43,
 |           "pressure": 1021.23,
 |           "sea_level": 1031.01,
 |           "grnd_level": 1021.23,
 |           "humidity": 100,
 |           "temp_kf": 1.55
 |         },
 |         "weather": [
 |           {
 |             "id": 800,
 |             "main": "Clear",
 |             "description": "clear sky",
 |             "icon": "01d"
 |           }
 |         ],
 |         "clouds": {
 |           "all": 0
 |         },
 |         "wind": {
 |           "speed": 4.76,
 |           "deg": 220.5
 |         },
 |         "rain": {
 |
 |         },
 |         "sys": {
 |           "pod": "d"
 |         },
 |         "dt_txt": "2016-06-24 12:00:00"
 |       },
 |       {
 |         "dt": 1466780400,
 |         "main": {
 |           "temp": 18.91,
 |           "temp_min": 17.45,
 |           "temp_max": 18.91,
 |           "pressure": 1020.54,
 |           "sea_level": 1030.39,
 |           "grnd_level": 1020.54,
 |           "humidity": 93,
 |           "temp_kf": 1.46
 |         },
 |         "weather": [
 |           {
 |             "id": 803,
 |             "main": "Clouds",
 |             "description": "broken clouds",
 |             "icon": "04d"
 |           }
 |         ],
 |         "clouds": {
 |           "all": 68
 |         },
 |         "wind": {
 |           "speed": 6.22,
 |           "deg": 223.002
 |         },
 |         "rain": {
 |
 |         },
 |         "sys": {
 |           "pod": "d"
 |         },
 |         "dt_txt": "2016-06-24 15:00:00"
 |       },
 |       {
 |         "dt": 1466791200,
 |         "main": {
 |           "temp": 17.18,
 |           "temp_min": 15.81,
 |           "temp_max": 17.18,
 |           "pressure": 1020.59,
 |           "sea_level": 1030.44,
 |           "grnd_level": 1020.59,
 |           "humidity": 88,
 |           "temp_kf": 1.37
 |         },
 |         "weather": [
 |           {
 |             "id": 500,
 |             "main": "Rain",
 |             "description": "light rain",
 |             "icon": "10d"
 |           }
 |         ],
 |         "clouds": {
 |           "all": 64
 |         },
 |         "wind": {
 |           "speed": 5.32,
 |           "deg": 220.501
 |         },
 |         "rain": {
 |           "3h": 0.065
 |         },
 |         "sys": {
 |           "pod": "d"
 |         },
 |         "dt_txt": "2016-06-24 18:00:00"
 |       }
 |     ]
 |   }
 */

struct WeatherForecast {

    static let dateFormatter:NSDateFormatter = {
        $0.dateFormat = "yyyy-MM-dd HH:mm:SS"
        return $0
    }(NSDateFormatter())

    let latitude:       String?
    let longitude:      String?
    let cityCode:       String?
    let cityName:       String?
    let countryCode:    String?
    let records:        [WeatherRecord]?

    static func decode(jsonDict: [String:AnyObject]) -> WeatherForecast? {

        var latitude:       String? = .None
        var longitude:      String? = .None

        var cityCode:       String? = .None
        var cityName:       String? = .None
        var countryCode:    String? = .None

        var records         = [WeatherRecord]()

        func decodeCity(city: [String:AnyObject]) {

            /// ignore the fact that it might be a number, a String is really
            /// what we want
            func grab(key: String) -> String?{
                if let x = city[key] {
                    return "\(x)"
                }
                return .None
            }

            func grabCoord(key: String) -> String?{
                if let dict = city["coord"] as? [String:AnyObject] {
                    if let x = dict[key] {
                        return "\(x)"
                    }
                }
                return .None
            }

            /// we're picky and discard most everything
            cityCode = grab("id")
            cityName = grab("name")
            countryCode = grab("country")
            latitude = grabCoord("lat")
            longitude = grabCoord("lon")
        }

        func decodeForecasts(forecasts: [[String:AnyObject]]) {
            for (_, dict) in forecasts.enumerate() {
                if let r = WeatherRecord.decode(dict) {
                    records.append(r)
                }
            }
        }

        /// we're picky and discard most everything
        if let cityValue = jsonDict["city"] as? [String:AnyObject] {
            decodeCity(cityValue)
        } else {
            print("null city received")
            return .None
        }


        if let forecasts = jsonDict["list"] as? [[String:AnyObject]] {
            decodeForecasts(forecasts)
        } else {
            print("no weather record received")
            return .None
        }

        let sortedRecord = records.sort {
            let r0 = $0
            let r1 = $1

            guard let d0 = r0.date else {
                return false
            }

            guard let d1 = r1.date else {
                return false
            }

            guard let t0 = self.dateFormatter.dateFromString(d0) else {
                return false
            }

            guard let t1 = self.dateFormatter.dateFromString(d1) else {
                return false
            }

            return t0.timeIntervalSince1970 <= t1.timeIntervalSince1970
        }

        return WeatherForecast(
            latitude:       latitude
        ,   longitude:      longitude
        ,   cityCode:       cityCode
        ,   cityName:       cityName
        ,   countryCode:    countryCode
        ,   records:        sortedRecord)
    }
}

struct WeatherRecord {

    let date:                   String?

    let temp:                   String?
    let temp_min:               String?
    let temp_max:               String?
    let pressure:               String?
    let sea_level:              String?
    let grnd_level:             String?
    let humidity:               String?
    let temp_kf:                String?

    let weather_id:             String?
    let weather_main:           String?
    let weather_description:    String?
    let weather_icon:           String?

    let clouds_percent:         String?

    let wind_speed:             String?
    let wind_deg:               String?

    let rain_3h:                String?

    static func decode(jsonDict: [String:AnyObject]) -> WeatherRecord? {

        let date:                   String?

        let temp:                   String?
        let temp_min:               String?
        let temp_max:               String?
        let pressure:               String?
        let sea_level:              String?
        let grnd_level:             String?
        let humidity:               String?
        let temp_kf:                String?

        let weather_id:             String?
        let weather_main:           String?
        let weather_description:    String?
        let weather_icon:           String?

        let clouds_percent:         String?

        let wind_speed:             String?
        let wind_deg:               String?
        
        let rain_3h:                String?

        func grab(key: String) -> String?{
            if let x = jsonDict[key] {
                return "\(x)"
            }
            return .None
        }

        func grabSub(subKey: String, key: String) -> String? {
            if let dict = jsonDict[subKey] as? [String:AnyObject] {
                if let x = dict[key] {
                    return "\(x)"
                }
            }
            return .None
        }

        func grabFirstSub(subKey: String, key: String) -> String? {
            if let array = jsonDict[subKey] as? [[String:AnyObject]] where array.count > 0 {
                let dict = array[0]
                if let x = dict[key] {
                    return "\(x)"
                }
            }
            return .None
        }

        date        = grab("dt_txt")

        temp        = grabSub("main", key: "temp")
        temp_min    = grabSub("main", key: "temp_min")
        temp_max    = grabSub("main", key: "temp_max")
        pressure    = grabSub("main", key: "pressure")
        sea_level   = grabSub("main", key: "sea_level")
        grnd_level  = grabSub("main", key: "grnd_level")
        humidity    = grabSub("main", key: "humidity")
        temp_kf     = grabSub("main", key: "temp_kf")

        weather_id          = grabFirstSub("weather", key: "id")
        weather_main        = grabFirstSub("weather", key: "main")
        weather_description = grabFirstSub("weather", key: "description")
        weather_icon        = grabFirstSub("weather", key: "icon")

        clouds_percent      = grabSub("clouds", key: "all")

        wind_speed  = grabSub("wind", key: "speed")
        wind_deg    = grabSub("wind", key: "deg")

        rain_3h     = grabSub("rain", key: "3h")


        return WeatherRecord(
            date:                   date
        ,   temp:                   temp
        ,   temp_min:               temp_min
        ,   temp_max:               temp_max
        ,   pressure:               pressure
        ,   sea_level:              sea_level
        ,   grnd_level:             grnd_level
        ,   humidity:               humidity
        ,   temp_kf:                temp_kf
        ,   weather_id:             weather_id
        ,   weather_main:           weather_main
        ,   weather_description:    weather_description
        ,   weather_icon:           weather_icon
        ,   clouds_percent:         clouds_percent
        ,   wind_speed:             wind_speed
        ,   wind_deg:               wind_deg
        ,   rain_3h:                rain_3h)
    }
}

