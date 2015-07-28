//
//  Tea.swift
//  Bento
//
//  Created by Peter Cho on 7/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Tea: CCNode {
    
    var teaHoldTime: Float = 0.75
    var touched = false
    var teaTimer: Float = 0
    
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
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
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
}
