//
//  Dish3.swift
//  Bento
//
//  Created by Peter Cho on 7/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Dish3: CCNode {
   
    func didLoadFromCCB() {
        userInteractionEnabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        NSNotificationCenter.defaultCenter().postNotificationName("dish3 served", object: nil)
        
        
    }
    
}
