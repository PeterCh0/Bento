//
//  Box1.swift
//  Bento
//
//  Created by Peter Cho on 7/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Box1: CCNode {
    
    weak var box1: CCSprite!
    
    func didLoadFromCCB() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("squishDish1"), name:"dish1 served", object: nil)
    }
   
    func squishDish1() {
        let squish = CCActionScaleTo(duration: 0.1, scale: 0.8)
        let unsquish = CCActionScaleTo(duration: 0.1, scale: 1)
        let seq = CCActionSequence(array: [squish, unsquish])
        box1.runAction(seq)
        //box1.runAction(unsquish)
    }
    
    override func onExit() {
        NSNotificationCenter.defaultCenter().removeObserver(self) // Remove from all notifications being observed
        super.onExit()
    }
}
