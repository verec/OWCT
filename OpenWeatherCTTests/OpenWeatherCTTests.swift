//
//  OpenWeatherCTTests.swift
//  OpenWeatherCTTests
//
//  Created by verec on 23/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import XCTest

@testable import OpenWeatherCT

class OpenWeatherCTTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConfigurationLatLon() {
        let created  = Configuration.create(latitude: 10.0, longitude: -10.0)

        let noCity = created.city == .None
        let noCountry = created.country == .None
        let noCityCode = created.cityCode == .None

        let yesLat = created.latitude == 10.0
        let yesLon = created.longitude == -10.0

        XCTAssert(noCity && noCountry && noCityCode && yesLat && yesLon)

    }    
}
