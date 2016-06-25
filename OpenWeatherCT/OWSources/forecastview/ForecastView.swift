//
//  ForecastView.swift
//  OpenWeatherCT
//
//  Created by verec on 23/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation
import UIKit

class ForecastView: UIView {

    private struct Parameters {
        static let cellClass                = ForecastCell.self
        static let cellIdentifier           = NSStringFromClass(cellClass)

        static let maxRows:CGFloat          = 7.0
    }

    let citySelector    = UISegmentedControl(
                            items: Presets.presets
                                .keys.map { $0 as String }.sort())
    let tableView       = UITableView(frame: CGRect.zero, style: .Plain)

}

extension ForecastView {

    func citySelectorChanged(_:UISegmentedControl) {
        let index = citySelector.selectedSegmentIndex
        let name = Presets.presets.keys.map { $0 as String }.sort()[index]
        if let code = Presets.presets[name] {
            WellKnown.Controllers.forecastLoader.load(code)
        }
    }

    func lazySetup() {
        self.addSubview(citySelector)
        citySelector.tintColor = Colors.Main.foreTextColor
        citySelector.addTarget(
            self
        ,   action:             #selector(ForecastView.citySelectorChanged(_:))
        ,   forControlEvents:   [.ValueChanged])

        citySelector.selectedSegmentIndex = 1 /// Paris

        self.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(Parameters.cellClass, forCellReuseIdentifier: Parameters.cellIdentifier)

        self.tableView.showsHorizontalScrollIndicator = true
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = .None
        self.backgroundColor = UIColor.clearColor()

        self.tableView.backgroundColor = UIColor.clearColor()
    }
}

extension ForecastView {

    override func layoutSubviews() {

        super.layoutSubviews()

        if !self.bounds.isDefined {
            return
        }

        if citySelector.orphaned {
            lazySetup()
        }

        let top = self.bounds.top(Sizes.CitySelector.height)
        let mid = self.bounds.shrink(.Top, by: Sizes.CitySelector.height)
                            .shrink(.Bottom, by: Sizes.Guides.bottomGuide)
                            .insetBy(dx:30.0, dy: 0.0)

        citySelector.sizeToFit()
        citySelector.frame = citySelector.bounds.centered(intoRect: top)
        tableView.frame = mid
    }
}

extension ForecastView {

    func reload() {
        reloadContents()
    }

    func reloadContents() {
        self.tableView.reloadSections(NSIndexSet(index:0), withRowAnimation: .Automatic)
    }
}

extension ForecastView {

    func bind(record: WeatherRecord?, cell: ForecastCell) {
        cell.view.weatherRecord = record
    }
}

extension ForecastView : UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let forecast = WellKnown.Model.currentForecast, let records = forecast.records {
            return records.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCellWithIdentifier(Parameters.cellIdentifier) as? ForecastCell else {
            assert(false, "This just cannot happen")
            return UITableViewCell()
        }
        if let forecast = WellKnown.Model.currentForecast, let records = forecast.records {
            let record = records[indexPath.row]
            bind(record, cell: cell)
        } else {
            assert(false)
            return UITableViewCell()
        }

        return cell
    }
}

extension ForecastView : UITableViewDelegate {

    /// technically a UITableViewDelegate _is a_ UIScrollViewDelegate, but it
    /// clearer to separate what belongs to the scrolView from what belongs
    /// to the tableView.

    func fixedRowHeight() -> CGFloat {
        return tableView.bounds.height / Parameters.maxRows
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return fixedRowHeight()
    }
}

extension ForecastView : UIScrollViewDelegate {

    /// technically a UITableViewDelegate _is a_ UIScrollViewDelegate, but it
    /// clearer to separate what belongs to the scrolView from what belongs
    /// to the tableView.

    /// This is so that when the table free scrolls in an intertial move it
    /// stops at cell boundaries, never displaying an incomplete cell.

    func scrollViewWillEndDragging(
        scrollView:                 UIScrollView
    ,   withVelocity velocity:      CGPoint
    ,   targetContentOffset:        UnsafeMutablePointer<CGPoint>) {

        targetContentOffset.memory = scrollView.snapToIntegerRowForProposedContentOffset(
            targetContentOffset.memory
        ,   rowHeight:  self.fixedRowHeight())
    }
}

