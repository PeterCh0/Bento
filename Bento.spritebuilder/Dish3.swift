//
//  Dish3.swift
//  Bento
//
//  Created by Peter Cho on 7/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Dish3: CCNode {
   
    var food: CCNode?
    var foods: [CCNode?] = []
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("disableTouch:"), name: "tutorial mode", object: nil)
    }
    
    func disableTouch(notification: NSNotification) {
        userInteractionEnabled = false
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        serveDish3()
    }
    
    func serveDish3() {
        NSNotificationCenter.defaultCenter().postNotificationName("dish3 served", object: nil)
        
        
        // autoplay animation of miniature food flying to customer
        food = CCBReader.load("Food3", owner: self) as! Food3
        foods.append(food)
        food!.position = CGPoint(x: boundingBox().size.width / 2, y: boundingBox().size.height / 2)
        self.addChild(food)
    }
    
    // call back from flying food ccb timeline to deallocate after animation ends.
    func despawnFood() {
        foods[0]!.removeFromParent()
        foods.removeAtIndex(0)
    }
    
    override func onExit() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.onExit()
    }
    
}
