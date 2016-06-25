//
//  Network.swift
//  OpenWeatherCT
//
//  Created by verec on 23/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation

struct Network {

    typealias MainThreadConmpletiuon = (NSError?, NSData?)->()

    func load(fullURL fullURL: NSURL?, uiCallWhenDone: MainThreadConmpletiuon) {

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
}