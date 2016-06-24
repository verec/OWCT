//
//  Network.swift
//  OpenWeatherCT
//
//  Created by verec on 23/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation

struct Network {

    struct Configuration {

/*
    Example:

    "http://api.openweathermap.org/data/2.5/forecast?q=London,uk&mode=json&appid=965c55c4f42900256742bc60d5dd1d89&cnt=5"
         
    Note: this being iOS9 and the endpoint being http (not https) this requires
    a special entry in the plist:
         
    <key>NSAppTransportSecurity</key>
    <dict>
         <key>NSAllowsArbitraryLoads</key>
         <true/>
    </dict>

 */

        static let iconEndPoint =   "http://openweathermap.org/img/w/"
        static let baseEndPoint =   "http://api.openweathermap.org/data/2.5/forecast"
        static let apiKey       =   "965c55c4f42900256742bc60d5dd1d89"

        static func configuredEndPoint(query:[String:String]) -> String {

            let baseDict:[String:String] = [
                "mode":     "json"
            ,   "appid":    apiKey
            ,   "units":    "metric"
            ]

            var configured = baseEndPoint
            var sep = "?"

            func appendQueryItemsFromDict(dict: [String:String]) {
                for (key, value) in dict {
                    configured += "\(sep)\(key)=\(value)"
                    sep = "&"
                }
            }

            appendQueryItemsFromDict(baseDict)
            appendQueryItemsFromDict(query)
            
            return configured
        }
    }

    typealias MainThreadConmpletiuon = (NSError?, NSData?)->()

    func load(
        fullURL:        NSURL?
    ,   uiCallWhenDone: MainThreadConmpletiuon) {

        func callCompletion(error:NSError?, data: NSData?) {
            GCD.MainQueue.async {
                uiCallWhenDone(error, data)
            }
        }

        /// offload the newtowrk request off the main thread
        GCD.SerialQueue1.async {

            if let url = fullURL {

                let request = NSURLRequest(URL: url)

                let session: NSURLSession

                if Features.Network.enforceNonMainThreadNetworkActivity {
                    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                    session = NSURLSession(configuration: config, delegate: nil, delegateQueue: NSOperationQueue())
                } else {
                    session = NSURLSession.sharedSession()
                }

                let task = session.dataTaskWithRequest(request) {
                    (data, response, error) in

                    callCompletion(error, data: data)
                }

                task.resume()
            } else {
                callCompletion(NSError(domain: "invalid url endpoint", code: -1, userInfo: nil), data: nil)
            }
        }
    }
    

    func load(
        query:          [String:String]
    ,   uiCallWhenDone: MainThreadConmpletiuon) {

        load(NSURL(string: Configuration.configuredEndPoint(query)), uiCallWhenDone: uiCallWhenDone)
    }
    
    func load(
        icon:           String
    ,   uiCallWhenDone: MainThreadConmpletiuon) {

        load(NSURL(string: Configuration.iconEndPoint + icon + ".png"), uiCallWhenDone: uiCallWhenDone)
    }
}