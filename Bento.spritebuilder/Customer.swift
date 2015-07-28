//
//  Customer.swift
//  Bento
//
//  Created by Peter Cho on 7/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Customer: CCNode {
    
    weak var orderLabel1: CCLabelTTF!
    weak var orderLabel2: CCLabelTTF!
    weak var orderLabel3: CCLabelTTF!
    weak var orderLabel4: CCLabelTTF!
    var order1 = 0
    var order2 = 0
    var order3 = 0
    var order4 = 0
    var orderTotal = 0
    var orderMultiplier: Float = 0
    var patience: Float = 10
    var payPerfect = 200
    var payGood = 160
    var payBad = 100
    var customerType: String = "customer type"
    
    func didLoadFromCCB() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("badOrder"), name:"bad order", object: nil)
        setOrder()
    }
    
    func setOrder() {
        order1 = Int(CCRANDOM_0_1() * orderMultiplier)
        orderLabel1.string = String(order1)
        order2 = Int(CCRANDOM_0_1() * orderMultiplier)
        orderLabel2.string = String(order2)
        order3 = Int(CCRANDOM_0_1() * orderMultiplier)
        orderLabel3.string = String(order3)
        order4 = Int(CCRANDOM_0_1() * orderMultiplier)
        orderLabel4.string = String(order4)
        orderTotal = order1 + order2 + order3 + order4

    }
    
    func badOrder() {
        self.animationManager.runAnimationsForSequenceNamed("Shocked")

    }
   
    override func onExit() {
        NSNotificationCenter.defaultCenter().removeObserver(self) // Remove from all notifications being observed

    }
}
