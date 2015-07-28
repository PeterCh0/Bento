//
//  FoodCritic.swift
//  Bento
//
//  Created by Peter Cho on 7/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class FoodCritic: CCNode {
    
    weak var orderLabel1: CCLabelTTF!
    weak var orderLabel2: CCLabelTTF!
    weak var orderLabel3: CCLabelTTF!
    weak var orderLabel4: CCLabelTTF!
    weak var customer: CCSprite!
    var order1 = 0
    var order2 = 0
    var order3 = 0
    var order4 = 0
    var orderTotal = 0
    var patience: Float = 10
    var payPerfect = 400
    var payGood = 160
    var payOkay = 130
    var payBad = 100
    
    func didLoadFromCCB() {
        setOrder()
    }
    
    func setOrder() {
        order1 = Int(CCRANDOM_0_1() * 5)
        orderLabel1.string = String(order1)
        order2 = Int(CCRANDOM_0_1() * 5)
        orderLabel2.string = String(order2)
        order3 = Int(CCRANDOM_0_1() * 5)
        orderLabel3.string = String(order3)
        order4 = Int(CCRANDOM_0_1() * 5)
        orderLabel4.string = String(order4)
        orderTotal = order1 + order2 + order3 + order4
        
    }
    
   
}
