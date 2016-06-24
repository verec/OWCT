//
//  TopLevel.swift
//  JustEat
//
//  Created by verec on 10/04/2016.
//  Copyright © 2016 Cantabilabs Ltd. All rights reserved.
//

import Foundation
import UIKit

class TopView: UIView {

    convenience init() {
        self.init(frame:CGRect.zero)
    }

    override init(frame:CGRect) {
        super.init(frame:frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension TopView {

    override func layoutSubviews() {
        super.layoutSubviews()

        if Views.Main.forecastView.orphaned {
            self.addSubview(Views.Main.forecastView)
            self.backgroundColor = Colors.Main.topViewBackgroundColor
        }

        Views.Main.forecastView.frame = self.bounds
    }
}