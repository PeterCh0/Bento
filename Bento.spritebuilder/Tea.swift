//
//  Tea.swift
//  Bento
//
//  Created by Peter Cho on 7/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Tea: CCNode {
    
    var teaHoldTime: Float = 0.5
    var touched = false
    var teaTimer: Float = 0

    func didLoadFromCCB() {
        userInteractionEnabled = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("disableTouch:"), name: "tutorial mode", object: nil)
    }
    
    func disableTouch(notification: NSNotification) {
        userInteractionEnabled = false
    }
    
    override func update(delta: CCTime) {
        if touched == true && teaTimer < teaHoldTime {
            teaTimer += Float(delta)
            // tea boiling animation
        }
        
        if teaTimer > teaHoldTime {
            // tea serving animation
            NSNotificationCenter.defaultCenter().postNotificationName("tea done", object: nil)
            teaTimer = 0
            touched = false
            self.animationManager.runAnimationsForSequenceNamed("ServeTea")

        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        touched = true
        self.animationManager.runAnimationsForSequenceNamed("BoilTea")

    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        touched = false
        self.animationManager.runAnimationsForSequenceNamed("Default Timeline")
        teaTimer = 0
    }
    
    override func onExit() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.onExit()
    }
}
