//
//  Tutorial.swift
//  Bento
//
//  Created by Peter Cho on 7/31/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Tutorial: CCNode {
    
    func back() {
        let mainMenuScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainMenuScene)
    }
   
}
