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

    static let calendar = NSCalendar.autoupdatingCurrentCalendar

    let weatherIcon    =   UIImageView()
    let plch    =   UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    let temp    =   UILabel()
    let wind    =   UILabel()
    let time    =   UILabel()

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
        self.addSubview(temp)
        self.addSubview(wind)
        self.addSubview(time)

        setupLabel(temp)
        setupLabel(wind)
        setupLabel(time)
    }

    func setupLabel(label: UILabel, text: String? = .None) {
        if let text = text {
            label.text = text
        }
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Left

        label.textColor = Colors.Main.foreTextColor
        label.font = Fonts.Main.tempCellFont
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
        if let celsius = weatherRecord.temp {
            let intTemp = Int(celsius.NS.doubleValue)
            temp.text = "\(intTemp) C"
        }

        if let speed = weatherRecord.wind_speed {
            wind.text = "\(speed) m/s"
        }

        if let date = weatherRecord.date {
            if let d = WeatherForecast.dateFormatter.dateFromString(date) {
                let hour = d.hour
                let dow = d.weekday
                let symbs = WeatherForecast.dateFormatter.weekdaySymbols

                if dow < symbs.count {
                    let text = "\(symbs[dow]) \(hour):00"
                    time.text = text
                }
            }
        }

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

        temp.sizeToFit()
        wind.sizeToFit()
        time.sizeToFit()

        let columns = self.bounds.tabStops([0.30, 0.70])

        temp.frame = temp.bounds.positionned(intoRect: self.bounds, widthUnitRange: 0.5, heightUnitRange: 0.25)
            .edge(.Left, alignedToRect: columns[0])

        wind.frame = wind.bounds.positionned(intoRect: self.bounds, widthUnitRange: 0.5, heightUnitRange: 0.50)
            .edge(.Left, alignedToRect: columns[0])

        time.frame = time.bounds.positionned(intoRect: self.bounds, widthUnitRange: 0.5, heightUnitRange: 0.75)
            .edge(.Left, alignedToRect: columns[0])
    }
}

