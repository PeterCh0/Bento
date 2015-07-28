//
//  GameOver.swift
//  Bento
//
//  Created by Peter Cho on 7/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class GameOver: CCNode {
    
    weak var goScoreLabel: CCLabelTTF!
    weak var goTimeLabel: CCLabelTTF!
    weak var goTeaLabel: CCLabelTTF!
    weak var goDishesServedLabel: CCLabelTTF!
    weak var goPerfectOrdersLabel: CCLabelTTF!
    
    func setResults (score: Int, time: Float, tea: Int, dishes: Int, perfect: Int) {
        goScoreLabel.string = String(Int(score))
        goTimeLabel.string = String(Int(time))
        goTeaLabel.string = String(tea)
        goDishesServedLabel.string = String(dishes)
        goPerfectOrdersLabel.string = String(perfect)
    }
    
}
