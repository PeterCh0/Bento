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
    weak var onigiri1: CCNode!
    weak var onigiri2: CCNode!
    weak var onigiri3: CCNode!
    weak var onigiri4: CCNode!
    var origOrder1 = 0
    var origOrder2 = 0
    var origOrder3 = 0
    var origOrder4 = 0
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("scaleDish1:"), name:"dish1 served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("scaleDish2:"), name:"dish2 served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("scaleDish3:"), name:"dish3 served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("scaleDish4:"), name:"dish4 served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("badOrder:"), name:"bad order", object: nil)
        
    }
    
    func checkEmptyOrders() {
        if order1 == 0 {
            onigiri1.visible = false
        }
        if order2 == 0 {
            onigiri2.visible = false
        }
        if order3 == 0 {
            onigiri3.visible = false
        }
        if order4 == 0 {
            onigiri4.visible = false
        }
    }
    
    func setTutorialOrder() {
        order1 = 3
        origOrder1 = order1
        orderLabel1.string = String(order1)
        order2 = 2
        origOrder2 = order2
        orderLabel2.string = String(order2)
        order3 = 4
        origOrder3 = order3
        orderLabel3.string = String(order3)
        order4 = 1
        origOrder4 = order4
        orderLabel4.string = String(order4)
        orderTotal = order1 + order2 + order3 + order4

        checkEmptyOrders()

    }

 
    func setOrder() {
        order1 = Int(CCRANDOM_0_1() * orderMultiplier)
        origOrder1 = order1
        orderLabel1.string = String(order1)
        order2 = Int(CCRANDOM_0_1() * orderMultiplier)
        origOrder2 = order2
        orderLabel2.string = String(order2)
        order3 = Int(CCRANDOM_0_1() * orderMultiplier)
        origOrder3 = order3
        orderLabel3.string = String(order3)
        order4 = Int(CCRANDOM_0_1() * orderMultiplier)
        origOrder4 = order4
        orderLabel4.string = String(order4)
        orderTotal = order1 + order2 + order3 + order4
        checkEmptyOrders()


    }
    
    func scaleDish1(notification: NSNotification) {
        
        if order1 == 0 {
            onigiri1.visible = false
        }
        else {
            let squish = CCActionScaleTo(duration: 0.1, scale: (Float(order1) / Float(origOrder1)) * 0.65)
            onigiri1.runAction(squish)
        }
        
    }
    
    func scaleDish2(notification: NSNotification) {
        
        if order2 == 0 {
            onigiri2.visible = false
        }
        else {
            //onigiri2.scale = Float(order2) / Float(origOrder2)
            let squish = CCActionScaleTo(duration: 0.1, scale: (Float(order2) / Float(origOrder2)) * 0.65)
            onigiri2.runAction(squish)
        }
    }
    
    func scaleDish3(notification: NSNotification) {
        
        if order3 == 0 {
            onigiri3.visible = false
        }
        else {
            let squish = CCActionScaleTo(duration: 0.1, scale: (Float(order3) / Float(origOrder3)) * 0.65)
            onigiri3.runAction(squish)
        }
    }
    
    func scaleDish4(notification: NSNotification) {
        
        if order4 == 0 {
            onigiri4.visible = false
        }
        else {
            let squish = CCActionScaleTo(duration: 0.1, scale: (Float(order4) / Float(origOrder4)) * 0.65)
            onigiri4.runAction(squish)
        }
    }
    
    func badOrder(notification: NSNotification) {
        self.animationManager.runAnimationsForSequenceNamed("Shocked")

    }
//   
    override func onExit() {
        NSNotificationCenter.defaultCenter().removeObserver(self) // Remove from all notifications being observed
        super.onExit()
    }

}
