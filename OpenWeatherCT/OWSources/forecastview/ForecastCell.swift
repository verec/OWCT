//
//  ForecastCell.swift
//  OpenWeatherCT
//
//  Created by verec on 24/06/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation
import UIKit

class ForecastCell: UITableViewCell {

    let view = ForecastCellView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        super.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(view)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ForecastCell {

    override func prepareForReuse() {
        super.prepareForReuse()
        view.weatherIcon.image = nil
    }
}

extension ForecastCell {

    override func setSelected(selected: Bool, animated: Bool) {
        /// we handle the selection ourselves.
    }

    override func setHighlighted(highlighted: Bool, animated: Bool) {
        /// we handle the hilight ourself
    }
}

extension ForecastCell {

    override func layoutSubviews() {

        super.layoutSubviews()

        if !self.contentView.bounds.isDefined {
            return
        }

        view.frame = self.contentView.bounds
    }
}
