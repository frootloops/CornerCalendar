//
//  Calendar.swift
//  Calendar
//
//  Created by Arsen Gasparyan on 13/07/15.
//  Copyright © 2015 Arsen Gasparyan. All rights reserved.
//

import Foundation

struct Calendar {
    subscript(index: Int) -> NSDate {
        return 365.days.ago + index.days
    }
}