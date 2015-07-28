//
//  Dish2.swift
//  Bento
//
//  Created by Peter Cho on 7/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Dish2: CCNode {
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        NSNotificationCenter.defaultCenter().postNotificationName("dish2 served", object: nil)
        
        
    }
}
