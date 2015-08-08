//
//  PersistentData.swift
//  Bento
//
//  Created by Peter Cho on 8/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class PersistentData {
    var highScoreEasy = NSUserDefaults.standardUserDefaults().integerForKey("highScoreEasy") ?? 0 {
        didSet{
            NSUserDefaults.standardUserDefaults().setInteger(highScoreEasy, forKey: "highScoreEasy")
            NSUserDefaults.standardUserDefaults().synchronize()
            //OP  creds Rushil Patel (Rushi)
        }
        
    }
    
    var highScoreHard = NSUserDefaults.standardUserDefaults().integerForKey("highScoreHard") ?? 0 {
        didSet{
            NSUserDefaults.standardUserDefaults().setInteger(highScoreHard, forKey: "highScoreHard")
            NSUserDefaults.standardUserDefaults().synchronize()
            //OP  creds Rushil Patel (Rushi)
        }
        
    }
}