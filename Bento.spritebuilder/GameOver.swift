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
    weak var highScoreGO: CCLabelTTF!
    weak var goTimeLabel: CCLabelTTF!
    weak var goTeaLabel: CCLabelTTF!
    weak var goDishesServedLabel: CCLabelTTF!
    weak var goPerfectOrdersLabel: CCLabelTTF!
    
    
    func setResults (score: Int, high: Int, time: Float, tea: Int, dishes: Int, perfect: Int) {
        goScoreLabel.string = String(Int(score))
        highScoreGO.string = String(high)
        goTimeLabel.string = String(Int(time))
        goTeaLabel.string = String(tea)
        goDishesServedLabel.string = String(dishes)
        goPerfectOrdersLabel.string = String(perfect)
    }
    
    func shareButtonTapped() {
        var scene = CCDirector.sharedDirector().runningScene
        var node: AnyObject = scene.children[0]
        var screenshot = screenShotWithStartNode(node as! CCNode)
        
        let sharedText = "This is some default text that I want to share with my users. [This is where I put a link to download my awesome game]"
        let itemsToShare = [screenshot, sharedText]
        
        var excludedActivities = [ UIActivityTypeAssignToContact,
            UIActivityTypeAddToReadingList, UIActivityTypePostToTencentWeibo]
        
        var controller = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        controller.excludedActivityTypes = excludedActivities
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func screenShotWithStartNode(node: CCNode) -> UIImage {
        CCDirector.sharedDirector().nextDeltaTimeZero = true
        var viewSize = CCDirector.sharedDirector().viewSize()
        var rtx = CCRenderTexture(width: Int32(viewSize.width), height: Int32(viewSize.height))
        rtx.begin()
        node.visit()
        rtx.end()
        return rtx.getUIImage()
    }
    
}
