//
//  GCD.swift
//  __core_sources
//
//  Created by verec on 22/06/2014.
//  Copyright (c) 2014 CantabiLabs. All rights reserved.
//

import Foundation

struct GCD {

    struct DefaultQueue {

        static func async(lambda: () -> ()) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), lambda)
        }

        static func sync(lambda: () -> ()) {
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), lambda)
        }
    }

    struct MainQueue {

        static func async(lambda: () -> ()) {
            dispatch_async(dispatch_get_main_queue(), lambda)
        }

        static func sync(lambda: () -> ()) {
            dispatch_sync(dispatch_get_main_queue(), lambda)
        }

        static func after(delay: NSTimeInterval, lambda: () -> ()) {
            let popn = dispatch_time(DISPATCH_TIME_NOW, Int64(floor(delay * NSTimeInterval(NSEC_PER_SEC))))

            dispatch_after(popn, dispatch_get_main_queue(), lambda)
        }
    }

    struct SerialQueue1 {

        struct Static {
            static let serialQz: dispatch_queue_t! = dispatch_queue_create("com.mac.verec.serial", DISPATCH_QUEUE_SERIAL)
        }

        static func async(lambda: () -> ()) {
            dispatch_async(Static.serialQz, lambda)
        }

        static func sync(lambda: () -> ()) {
            dispatch_sync(Static.serialQz, lambda)
        }
    }

    struct SerialQueue2 {

        static func async(lambda: () -> ()) {
            struct Static {
                static let serialQ: dispatch_queue_t! = dispatch_queue_create("com.mac.verec.serial.2", DISPATCH_QUEUE_SERIAL)
            }
            dispatch_async(Static.serialQ, lambda)
        }
    }


    struct ConcurrentQueue1 {

        static func async(lambda: () -> ()) {

            struct Static {
                static let concurrentQ: dispatch_queue_t! = dispatch_queue_create("com.mac.verec.concurrent.1", DISPATCH_QUEUE_CONCURRENT)
            }

            dispatch_async(Static.concurrentQ, lambda)
        }
    }

    struct ObjC {
        static func synchronized(lock: AnyObject, closure: () -> ()) {
            objc_sync_enter(lock)
            closure()
            objc_sync_exit(lock)
        }
    }
}

