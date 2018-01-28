//
//  Session.swift
//  Mindful Moment
//
//  Created by Christopher Boynton on 12/18/17.
//  Copyright © 2017 Christopher Boynton. All rights reserved.
//

import Foundation

struct Session {
    var startDate: Date
    var endDate: Date
    var duration: TimeInterval { return endDate.timeIntervalSince(startDate)}

    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}

