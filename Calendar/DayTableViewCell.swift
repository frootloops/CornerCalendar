//
//  DayTableViewCell.swift
//  Calendar
//
//  Created by Arsen Gasparyan on 13/07/15.
//  Copyright © 2015 Arsen Gasparyan. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {
    internal var date: NSDate!
    internal var nextDate: NSDate!
    internal var currentIndexPath: NSIndexPath!
    internal var indexPath: NSIndexPath!
    
    private let blurColor = UIColor(red: 62/255.0, green: 116/255.0, blue: 255/255.0, alpha: 1)
    private let redColor = UIColor(red: 1, green: 82/255.0, blue: 84/255.0, alpha: 1)
    private let grayColor = UIColor(red: 138/255.0, green: 138/255.0, blue: 138/255.0, alpha: 1)
    private var formatter = NSDateFormatter()
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    
    internal func prepareForUse() {
        formatter.locale = NSLocale(localeIdentifier: "RU_ru")
        formatter.dateFormat = "EE dd"
        dayLabel.text = formatter.stringFromDate(date).lowercaseString
        dayLabel.textColor = grayColor
        
        if date.weekday == 1 || date.weekday == 7 {
            weenEnd()
        }
        
        monthLabel.hidden = true
        if date.month != nextDate.month || currentIndexPath.row == indexPath.row {
            betweenMonths()
        }
        
        yearLabel.hidden = true
        if date.year != nextDate.year || currentIndexPath.row == indexPath.row {
            betweenYears()
        }
        
        if currentIndexPath.row == indexPath.row {
            selectedDay()
        }
    }
    
    // MARK: - Private Area
    
    private func weenEnd() {
        dayLabel.textColor = redColor
    }
    
    private func betweenMonths() {
        formatter.dateFormat = "MMM"
        
        monthLabel.text = formatter.stringFromDate(date).capitalizedString
        monthLabel.textColor = grayColor
        monthLabel.hidden = false
    }
    
    private func betweenYears() {
        formatter.dateFormat = "y"
        
        yearLabel.text = formatter.stringFromDate(date).capitalizedString
        yearLabel.textColor = grayColor
        yearLabel.hidden = false
    }
    
    private func selectedDay() {
        dayLabel.textColor = blurColor
        monthLabel.textColor = blurColor
        yearLabel.textColor = blurColor
    }
}
