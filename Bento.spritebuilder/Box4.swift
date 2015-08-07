//
//  Box4.swift
//  Bento
//
//  Created by Peter Cho on 7/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Box4: CCNode {
    
    weak var box4: CCSprite!
    
    func didLoadFromCCB() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("squishDish4"), name:"dish4 served", object: nil)
    }
    
    func squishDish4() {
        let squish = CCActionScaleTo(duration: 0.1, scale: 0.8)
        let unsquish = CCActionScaleTo(duration: 0.1, scale: 1)
        let seq = CCActionSequence(array: [squish, unsquish])
        box4.runAction(seq)
    }
    
    override func onExit() {
        NSNotificationCenter.defaultCenter().removeObserver(self) // Remove from all notifications being observed
        super.onExit()
    }
   
}
