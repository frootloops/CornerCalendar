//
//  TableViewController.swift
//  Calendar
//
//  Created by Arsen Gasparyan on 13/07/15.
//  Copyright © 2015 Arsen Gasparyan. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UIScrollViewDelegate, UITableViewDataSource {
    private let calendar = Calendar()
    private var currentIndexPath = NSIndexPath(forItem: 15, inSection: 0)
    private var borderView: UIView!
    private let blurColor = UIColor(red: 62/255.0, green: 116/255.0, blue: 255/255.0, alpha: 1)
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rateButton: UIButton!

    
    override func viewDidLayoutSubviews() {
        createOverlay()
        renderBorders()
        transfromRateButton()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 365
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("day", forIndexPath: indexPath) as! DayTableViewCell
        cell.date = calendar[indexPath.row]
        cell.nextDate = calendar[indexPath.row + 1]
        cell.currentIndexPath = currentIndexPath
        cell.indexPath = indexPath
        cell.prepareForUse()

        return cell
    }
    
    // MARK: - Scroll View Delegate
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        highlightCentralRow()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        highlightCentralRow()
        tableView.scrollToRowAtIndexPath(currentIndexPath, atScrollPosition: .Middle, animated: true)
        tableView.reloadRowsAtIndexPaths(tableView.indexPathsForVisibleRows()!, withRowAnimation: UITableViewRowAnimation.None)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? ExchangeViewController {
            controller.date = calendar[currentIndexPath.row]
        }
    }
    
    // MARK: - Private Area
    
    private func createOverlay() {
        let gradientLayer = CAGradientLayer()
        let from = UIColor.whiteColor()
        let to = UIColor(red: 238/255.0, green: 238/255.0, blue: 243/255.0, alpha: 0)
        
        gradientLayer.frame = overlayView.bounds
        gradientLayer.colors = [from.CGColor, to.CGColor]
        overlayView.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    private func highlightCentralRow() {
        let point = tableView.convertPoint(view.center, fromView: view)
        if let indexPath = tableView.indexPathForRowAtPoint(point) {
            currentIndexPath = indexPath
        }
    }
    
    private func renderBorders() {
        tableView.scrollToRowAtIndexPath(currentIndexPath, atScrollPosition: .Middle, animated: false)
        
        let deepRect = tableView.rectForRowAtIndexPath(currentIndexPath)
        let frame = tableView.convertRect(deepRect, toView: view)
        
        borderView = UIView(frame: frame)
        borderView.userInteractionEnabled = false
        borderView.backgroundColor = UIColor.clearColor()
        borderView.addTopBorderWithHeight(1, color: blurColor)
        borderView.addBottomBorderWithHeight(1, color: blurColor)
        
        view.addSubview(borderView)
    }
    
    private func transfromRateButton() {
        rateButton.layer.cornerRadius = 50
        rateButton.clipsToBounds = true
        rateButton.layer.borderColor = blurColor.CGColor
        rateButton.layer.borderWidth = 1
    }

}
