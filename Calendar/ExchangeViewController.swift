//
//  ExchangeViewController.swift
//  Calendar
//
//  Created by Arsen Gasparyan on 14/07/15.
//  Copyright © 2015 Arsen Gasparyan. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var euroLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    internal var date: NSDate!

    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true) {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentDate()
        fetchExchangeRates()
    }
    
    private func fetchExchangeRates() {
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(createRequest()) { [unowned self] (data, response, error) in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.indicator.stopAnimating()
            }
            
            if let e = error {
                NSOperationQueue.mainQueue().addOperationWithBlock() {
                    JLToast.makeText(e.localizedDescription).show()
                }
            } else {
                NSOperationQueue.mainQueue().addOperationWithBlock() {
                    self.parseXML(data)
                }
            }
        }
        
        task.resume()
    }
    
    private func parseXML(data: NSData!) {
        if let string = NSString(data: data, encoding:NSWindowsCP1251StringEncoding) as? String {
            let xml = SWXMLHash.parse(string)
            if let usd = xml["ValCurs"]["Valute"][9]["Value"].element?.text?.floatConverter {
                usdLabel.text = "1 USD = \(Int(usd)) RUB"
            } else {
                usdLabel.text = "1 USD = ? RUB"
            }
            
            if let eur = xml["ValCurs"]["Valute"][10]["Value"].element?.text?.floatConverter {
                euroLabel.text = "1 EUR = \(Int(eur)) RUB"
            } else {
                euroLabel.text = "1 EUR = ? RUB"
            }
            
            UIView.animateWithDuration(0.3) { self.usdLabel.alpha = 1 }
            UIView.animateWithDuration(0.3) { self.euroLabel.alpha = 1 }
        }
    }
    
    private func createRequest() -> NSURLRequest {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        
        let url = NSURL(string: "http://www.cbr.ru/scripts/XML_daily.asp?date_req=\(formatter.stringFromDate(date))")
        let request = NSURLRequest(URL: url!)
        
        return request
    }
    
    
    private func presentDate() {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "RU_ru")
        formatter.dateFormat = "d MMMM y"
        
        
        dateLabel.text = formatter.stringFromDate(date)
    }
}


extension String {
    var floatConverter: Float {
        let converter = NSNumberFormatter()
        converter.decimalSeparator = "."
        if let result = converter.numberFromString(self) {
            return result.floatValue
        } else {
            converter.decimalSeparator = ","
            if let result = converter.numberFromString(self) {
                return result.floatValue
            }
        }
        return 0
    }
}
