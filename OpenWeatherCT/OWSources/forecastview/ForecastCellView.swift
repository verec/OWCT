//
//  ForecastCellView.swift
//  OpenWeatherCT
//
//  Created by verec on 24/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation
import UIKit

import QuartzCore

class ForecastCellView: UIView {

    var refresher:((Int)->())?

    let weatherIcon    =   UIImageView()
    let plch    =   UIActivityIndicatorView(activityIndicatorStyle: .Gray)
//    let name    =   UILabel()
//    let food    =   UILabel()
//    let nrat    =   UILabel()
//    let addr    =   UILabel()
//    let rtng    =   FingerSlider()

    var weatherRecord: WeatherRecord? {
        didSet {
            applyWeatherRecord()
            self.setNeedsLayout()
        }
    }

    convenience init() {
        self.init(frame:CGRect.zero)
    }

    override init(frame:CGRect) {
        super.init(frame:frame)

        setup()

        self.setNeedsLayout()

        let o = ObjectIdentifier(self)
        print("init \(o.hashValue)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        let o = ObjectIdentifier(self)
        print("deinit \(o.hashValue)")
    }
}

extension ForecastCellView {

    func setup() {
        self.addSubview(weatherIcon)
        self.addSubview(plch)
//        self.addSubview(name)
//        self.addSubview(addr)
//        self.addSubview(food)
//        self.addSubview(nrat)
//        self.addSubview(rtng)
//
//        rtng.trackColor = Colors.themeColor.colorWithAlphaComponent(0.2)
//        rtng.thumbColor = Colors.themeColor2.colorWithAlphaComponent(0.8)
//        rtng.gaugeOnly = true
//
//        setupLabel(name)
//        name.textColor = Colors.MainPage.restaurantNameColor
//        name.font = Fonts.MainPage.nameCellFont
//
//        setupLabel(food)
//        food.textColor = Colors.MainPage.restaurantFoodColor
//        food.font = Fonts.MainPage.foodCellFont
//
//        setupLabel(nrat)
//        nrat.textColor = Colors.MainPage.restaurantNratColor
//        nrat.font = Fonts.MainPage.nratCellFont
//
//        setupLabel(addr)
//        addr.textColor = Colors.MainPage.restaurantAddrColor
//        addr.font = Fonts.MainPage.addrCellFont
    }

    func setupLabel(label: UILabel, text: String? = .None) {
        if let text = text {
            label.text = text
        }
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Left
    }
}

extension ForecastCellView {

    func applyWeatherRecord() {
        guard let weatherRecord = self.weatherRecord else {
            return
        }

        /// do we have an icon to show?
        if let icon = weatherRecord.weather_icon {
            if let _ = self.weatherIcon.image {
                /// we're golden
            } else {
                WellKnown.Network.loader.load(icon) {
                    if let image = $0 {
                        self.weatherIcon.image = image
                        self.setNeedsLayout()
                        self.setNeedsDisplay()
                    }
                }
            }
        }
//        name.text = restaurant.name
//        addr.text = restaurant.postcode + " " + restaurant.address
//
//        var text = ""
//        for f in restaurant.food {
//            if text.characters.count > 0 {
//                text += ", "
//            }
//            text += f
//        }
//        food.text = text
//
//        let ratingRange = Model.restaurantList.maxRating - Model.restaurantList.minRating
//        rtng.unitValue = (restaurant.rating - Model.restaurantList.minRating) / ratingRange
//
//        /// do we have the asset in the cache?
//        if let image = Model.restaurantList.metaData[restaurant.id]?.image {
//            weatherIcon.image = image
//        } else {
//            /// go fetch it
//            if let logoURL = restaurant.logoURL {
//                WellKnown.loader.loadImage(logoURL) {
//                    let data = $0
//                    if let data = data {
//                        if let image = UIImage(data: data) {
//                            Model.restaurantList.metaData[restaurant.id]?.image = image
//                            self.refresher?(restaurant.id)
//                        }
//                    }
//                }
//            }
//        }
//
//        weatherIcon.bounds = CGRect.zero.square(50.0)

        self.setNeedsLayout()
        self.setNeedsDisplay()
    }
}

extension ForecastCellView {

    override func layoutSubviews() {
        super.layoutSubviews()

        if !self.bounds.isDefined {
            return
        }
//
        let logoView:UIView
        if let _ = weatherIcon.image {
            plch.stopAnimating()
            plch.hidden = true
            weatherIcon.hidden = false
            logoView = weatherIcon
        } else {
            plch.hidden = false
            weatherIcon.hidden = true
            plch.startAnimating()
            logoView = plch
        }

        logoView.frame = CGRect.zero.square(50).centered(intoRect: self.bounds)
            .edge(.Left, alignedToRect: self.bounds)
            .edge(.Left, offsetBy: -10.0)
//
//        name.sizeToFit()
//        addr.sizeToFit()
//        food.sizeToFit()
//        nrat.sizeToFit()
//
//        let columns = self.bounds.tabStops([0.30, 0.70])
//
//        addr.bounds.size.width = (columns[1].origin.x - columns[0].origin.x) - 10.0
//
//        name.frame = name.bounds.positionned(intoRect: self.bounds, widthUnitRange: 0.5, heightUnitRange: 0.25)
//            .edge(.Left, alignedToRect: columns[0])
//        addr.frame = addr.bounds.positionned(intoRect: self.bounds, widthUnitRange: 0.5, heightUnitRange: 0.25 + 0.20)
//            .edge(.Left, alignedToRect: columns[0])
//        food.frame = food.bounds.positionned(intoRect: self.bounds, widthUnitRange: 0.5, heightUnitRange: 0.62)
//            .edge(.Left, alignedToRect: columns[0])
//
//        let rect = CGRect.zero.square(50.0).withHeight(5.0)
//        rtng.frame = rect.centered(intoRect: self.bounds)
//            .edge(.Right, alignedToRect: self.bounds)
//            .edge(.Right, offsetBy: -10.0)
//        

    }
}

