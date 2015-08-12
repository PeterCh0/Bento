//
//  Gameplay.swift
//  Bento
//
//  Created by Peter Cho on 7/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//  320x568

// finish tutorial
// more visual cues for timer
// balance perfect order and tea bonuses
// recap layer
// local storage
// draw other customers
// sound effects and bg music


import UIKit
import GameKit
import Mixpanel

enum TutorialPhase {
    case Phase1
    case Phase2
    case Phase3
    case Phase4
    case Phase5
    case Phase6
}

enum DifficultyScale {
    case Easy
    case Medium
    case Hard
    case Insane
    case Impossible
    case God
}

enum GameDifficulty {
    case Easy
    case Hard
    case Tutorial
}

enum GameState {
    case Playing
    case Frenzy
    case Gameover
}

class Gameplay: CCScene, CCPhysicsCollisionDelegate {
    
    // MARK: variables
        
    // mixpanel  implementation
    let mixpanel: Mixpanel = Mixpanel.sharedInstance()
    
    // highscore class
    var persistentData: PersistentData = PersistentData()
    
    weak var register: CCNode!
    weak var timer: CCNode!
    
    // Code connections
    
    var fadeTransition: CCTransition = CCTransition(fadeWithDuration: 1)
    
    // tutorial stuff:
    var tutorialPhase: TutorialPhase = .Phase1
    weak var tapIconNode1: CCNode!
    weak var tapIconNode2: CCNode!
    weak var tapIconNode3: CCNode!
    weak var tapIconNode4: CCNode!
    weak var tutorialMessage1: CCNode!
    weak var tutorialMessage2: CCNode!
    weak var tutorialMessage3: CCNode!
    weak var tutorialMessage4: CCNode!
    weak var tutorialTeaNode: CCNode!
    var tutorialMessage1Timer: Float = 0
    var tutorialMessage2Timer: Float = 0
    var tutorialMessage3Timer: Float = 0
    var tutorialMessage4Timer: Float = 0
    var tutorialMessage5Timer: Float = 0
    var tutorialMessage6Timer: Float = 0
    var tapIcon1: CCNode?
    var tapIcon2: CCNode?
    var tapIcon3: CCNode?
    var tapIcon4: CCNode?
    var tapArrow1: CCNode?
    var tapArrow2: CCNode?
    var tapArrow3: CCNode?
    var tapArrow4: CCNode?
    var tapArrow5: CCNode?
    var tapArrowTea: CCNode?
    var holdIcon: CCNode?
    
    
    var customerTapIcon: CCNode?
    var tapWarning = false
    
    // HUD buttons
    weak var gameRetryButton: CCLabelTTF!
    weak var menuButton: CCLabelTTF!
    
    var coin: CCNode!
    
    weak var plateNode: CCNode!
    
    // Four main input buttons + rice + tea
    weak var button1: CCButton!
    weak var button2: CCButton!
    weak var button3: CCButton!
    weak var button4: CCButton!
    weak var serveTeaButton: CCButton!
    
    // dish nodes
    weak var dishNode1: Dish1!
    weak var dishNode2: Dish2!
    weak var dishNode3: Dish3!
    weak var dishNode4: Dish4!
    
    // score label
    weak var payoutLabel: CCLabelTTF!
    
    // invisible button over the customer to serve
    weak var serveButton: CCButton!
    
    // retry button once the day finishes
    weak var retryButton: CCButton!
    
    // meter for the customer patience level
    weak var lifeBar: CCSprite!
    weak var lifeBarBG: CCNode!
    
    // icons for the tip bonus mechanic
    weak var bonusFish1: CCSprite!
    weak var bonusFish2: CCSprite!
    weak var bonusFish3: CCSprite!
    
    // node positioned for adding the customers
    weak var customerNode: CCNode!
    
    // label for time left with time gain and loss
    weak var timeLeftLabel: CCLabelTTF!
    var timeBonus: Float = 0
    var timeLeft: Float = 0
    var timePerfect: Float = 3
    var timeGood: Float = 2
    var timeBad: Float = 1
    
    // Total time of the day
    var totalTime: Float = 30
    var totalTimer: Float = 0
    
    // Customer variables
    var customer: Customer?
    
    // bonuses
    var teaBonus = 1000
    var comboBonus = 1000
    
    // Accuracy threshold for different amounts of points system
    var accuracyGood = 3
    var accuracyBad = 5

    // Variables for tip combo
    var combo: [CCSprite] = []
    var comboCounter = 0
    
    // Order variables from the customer
    var orderCount1 = 0
    var orderCount2 = 0
    var orderCount3 = 0
    var orderCount4 = 0
    var totalOrderCount = 0
    var currentOrders = 0
    
    // Serving input variables
    var servingCount1 = 0
    var servingCount2 = 0
    var servingCount3 = 0
    var servingCount4 = 0
    var totalServingCount = 0
    
    // animation timers
    var isBadOrder = false
    var badOrderTimer: Float = 0
    var badOrderTime: Float = 1
    
    // Game over node
    weak var gameOverNode: CCNode!
    
    // Game Over stats
    var tea: Tea?
    var teaServed = 0
    var dishesServed = 0
    var perfectOrders = 0
    
    // Customer payout distribution variables
    var payIncrease = 0
    var payPerfect = 0
    var payGood = 0
    var payBad = 0
    var payout = 0
//    var payout = 0 {
//        didSet {
////            scoreBonusLabel.string = String(payIncrease)
////            scoreBonusLabel.visible = true
////            scorePlusLabel.visible = true
////            timeBonusLabel.string = String(stringInterpolationSegment: timeBonus)
////            timeBonusLabel.visible = true
////            timePlusLabel.visible = true
//        }
//    }
    
    // score and time bonus labels and timer
//    var bonusTimer: Float = 0
//    weak var timePlusLabel: CCLabelTTF!
//    weak var timeBonusLabel: CCLabelTTF!
//    weak var scorePlusLabel: CCLabelTTF!
//    weak var scoreBonusLabel: CCLabelTTF!
    
    // Gamestate enum
    var gameState: GameState = .Playing
    
    // Game difficulty enum and times
    var gameDifficulty: GameDifficulty = .Hard
    var mediumTime: Float = 10
    var hardTime: Float = 17
    var insaneTime: Float = 25
    var impossibleTime: Float = 35
    var godTime: Float = 50
    
    var plate: Plate?
    
    // Difficulty customer scaling based on time left
    var difficultyScale: DifficultyScale = .Easy
    
    // Customer patience level variable with accordingly adjusted timer
    var patienceLevel: Float = 1
    var patienceLeft: Float = 0 {
        didSet {
            if gameDifficulty != .Tutorial {
                patienceLeft = max(min(patienceLeft, patienceLevel), 0)
                lifeBar.scaleX = patienceLeft / Float(patienceLevel) * 0.7
            }
        }
    }
    
    
    // play any openning animations
    func didLoadFromCCB() {

        lifeBarBG.zOrder -= 1
        lifeBar.zOrder -= 1
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("serveDish1:"), name:"dish1 served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("serveDish2:"), name:"dish2 served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("serveDish3:"), name:"dish3 served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("serveDish4:"), name:"dish4 served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("serveTea:"), name:"tea done", object: nil)


        timeLeft = totalTime
//        combo = [bonusFish1, bonusFish2, bonusFish3]
        userInteractionEnabled = true
            
    } // didLoadFromCCB()
    
    override func onEnter() {
        super.onEnter()
        spawnCustomer()
        
        if gameDifficulty == .Easy {
            mixpanel.track("Game Loaded", properties: ["Game Mode": "Easy"])
        }
        
        if gameDifficulty == .Hard {
            mixpanel.track("Game Loaded", properties: ["Game Mode": "Hard"])
        }

        if gameDifficulty == .Tutorial {
            
            mixpanel.track("Game Loaded", properties: ["Game Mode": "Tutorial"])
            
            NSNotificationCenter.defaultCenter().postNotificationName("tutorial mode", object: nil)
            serveButton.visible = false
            startTutorialPhase1()
            
        }
    }
    
    override func onExit() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.onExit()
    }
    
    override func update(delta: CCTime) {

        if gameDifficulty == .Tutorial {
            
            if tutorialPhase == .Phase1 {
                tutorialMessage1Timer += Float(delta)
                
                if tutorialMessage1Timer > 3.5 {
                    endTutorialPhase1()
                    tutorialPhase = .Phase2
                }
            }
            
            if tutorialPhase == .Phase2 {
                
                if tutorialMessage2Timer == 0 {
                    startTutorialPhase2()
                }
                tutorialMessage2Timer += Float(delta)
            }
            
            if tutorialPhase == .Phase3 {
                
                if tutorialMessage3Timer == 0 {
                    startTutorialPhase3()
                }
                tutorialMessage3Timer += Float(delta)
            }
            
            if tutorialPhase == .Phase4 {
                
                if tutorialMessage4Timer == 0 {
                    startTutorialPhase4()
                }
                tutorialMessage4Timer += Float(delta)
            }
            
            if tutorialPhase == .Phase5 {
                
                if tutorialMessage5Timer == 0 {
                    startTutorialPhase5()
                }
                tutorialMessage5Timer += Float(delta)
            }
            
            if tutorialPhase == .Phase6 {
                
                if tutorialMessage6Timer == 0 {
                    startTutorialPhase6()
                }
                tutorialMessage6Timer += Float(delta)
            }
        }
        else {
            
            if gameState == .Playing {
                
                timeLeft -= Float(delta)
                timeLeftLabel.string = String(Int(timeLeft))
                patienceLeft -= Float(delta)
                totalTimer += Float(delta)
                
                if patienceLeft < 1.5 && tapWarning == false {
                    tapWarning = true
                    customerTapIcon = CCBReader.load("TapIcon")

                    customerNode.addChild(customerTapIcon)
                }
                
                if totalTimer > godTime {
                    difficultyScale = .God
                }
                
                else if totalTimer > impossibleTime {
                    difficultyScale = .Impossible
                }
                
                else if totalTimer > insaneTime {
                    difficultyScale = .Insane
                }
                
                else if totalTimer > hardTime {
                    difficultyScale = .Hard
                }
                
                else if totalTimer > mediumTime {
                    difficultyScale = .Medium
                }
            
                if patienceLeft == 0 {

                    tapWarning = false
                    if let customerTapIco = customerTapIcon {
                        customerTapIco.removeFromParent()
                    }
                    plate!.removeFromParent()
                    customer!.removeFromParent()

                    reset()
                    spawnCustomer()
                }
            
//                if scoreBonusLabel.visible == true {
//                    bonusTimer += Float(delta)
//                }
//            
//                if bonusTimer > 0.3 {
//                    
//                    scoreBonusLabel.visible = false
//                    scorePlusLabel.visible = false
//                    timePlusLabel.visible = false
//                    timeBonusLabel.visible = false
//                    bonusTimer = 0
//                }
                
                if isBadOrder == true {
                    
                    badOrderTimer += Float(delta)
                    if badOrderTimer > badOrderTime {
                        isBadOrder = false
                        badOrderTimer = 0

                    }
                }
                
                if timeLeft <= 0 {
                    gameover()
                }
                
            } // if user is playing
            
        } // if user is not in tutorial mode
        
    } // update loop
    
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    // MARK: tutorial stuff
    
    func startTutorialPhase1() {
        
        let messagePos = CGPoint(x: CCDirector.sharedDirector().viewSize().width * 0.5, y: CCDirector.sharedDirector().viewSize().height * 0.6)
        let moveMessage = CCActionMoveTo(duration: 0.3, position: messagePos)
        tutorialMessage1.position = CGPoint(x: CCDirector.sharedDirector().viewSize().width * -0.50, y: CCDirector.sharedDirector().viewSize().height * 0.6)
        tutorialMessage1.runAction(moveMessage)
        tapIcon1 = CCBReader.load("TapIcon")
        tapIcon2 = CCBReader.load("TapIcon")
        tapIcon3 = CCBReader.load("TapIcon")
        tapIcon4 = CCBReader.load("TapIcon")
        tapIconNode1.addChild(tapIcon1)
        tapIconNode2.addChild(tapIcon2)
        tapIconNode3.addChild(tapIcon3)
        tapIconNode4.addChild(tapIcon4)
        
    }
    
    func endTutorialPhase1() {
        
        let messagePos = CGPoint(x: CCDirector.sharedDirector().viewSize().width * 1.5, y: CCDirector.sharedDirector().viewSize().height * 0.6)
        let moveMessage = CCActionMoveTo(duration: 0.3, position: messagePos)
        tutorialMessage1.runAction(moveMessage)
        tapIcon1?.removeFromParent()
        tapIcon2?.removeFromParent()
        tapIcon3?.removeFromParent()
        tapIcon4?.removeFromParent()
    }
    
    func startTutorialPhase2() {
        tapArrow1 = CCBReader.load("TapArrow")
        tapArrow2 = CCBReader.load("TapArrow")
        tapArrow3 = CCBReader.load("TapArrow")
        tapArrow4 = CCBReader.load("TapArrow")
        tapIconNode1.addChild(tapArrow1)
        tapIconNode2.addChild(tapArrow3)
        tapIconNode3.addChild(tapArrow2)
        tapIconNode4.addChild(tapArrow4)


        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("pushBox1"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("pushBox1"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: Selector("pushBox1"), userInfo: nil, repeats: false)

        NSTimer.scheduledTimerWithTimeInterval(3.5, target: self, selector: Selector("pushBox2"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("pushBox2"), userInfo: nil, repeats: false)

        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("pushBox3"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(5.5, target: self, selector: Selector("pushBox3"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: Selector("pushBox3"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(6.5, target: self, selector: Selector("pushBox3"), userInfo: nil, repeats: false)

        NSTimer.scheduledTimerWithTimeInterval(7.5, target: self, selector: Selector("pushBox4"), userInfo: nil, repeats: false)

        NSTimer.scheduledTimerWithTimeInterval(8.5, target: self, selector: Selector("endTutorialPhase2"), userInfo: nil, repeats: false)
        //endTutorialPhase2()
    }
    
    func endTutorialPhase2() {
        tapArrow1?.removeFromParent()
        tapArrow2?.removeFromParent()
        tapArrow3?.removeFromParent()
        tapArrow4?.removeFromParent()

        tutorialPhase = .Phase3
    }
    
    func startTutorialPhase3() {
        tapArrow5 = CCBReader.load("TapArrow")
        customerNode.addChild(tapArrow5)
        let messagePos = CGPoint(x: CCDirector.sharedDirector().viewSize().width * 0.5, y: CCDirector.sharedDirector().viewSize().height * 0.4)
        let moveMessage = CCActionMoveTo(duration: 0.3, position: messagePos)
        tutorialMessage2.position = CGPoint(x: CCDirector.sharedDirector().viewSize().width * -0.50, y: CCDirector.sharedDirector().viewSize().height * 0.4)
        tutorialMessage2.runAction(moveMessage)
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("serveCustomer"), userInfo: nil, repeats: false)
        
        NSTimer.scheduledTimerWithTimeInterval(3.5, target: self, selector: Selector("endTutorialPhase3"), userInfo: nil, repeats: false)
        
    }
    
    func endTutorialPhase3() {
        tapArrow5?.removeFromParent()
        let messagePos = CGPoint(x: CCDirector.sharedDirector().viewSize().width * 1.5, y: CCDirector.sharedDirector().viewSize().height * 0.4)
        let moveMessage = CCActionMoveTo(duration: 0.3, position: messagePos)
        tutorialMessage2.runAction(moveMessage)
        tutorialPhase = .Phase4
    }
    
    func startTutorialPhase4() {
        let messagePos = CGPoint(x: CCDirector.sharedDirector().viewSize().width * 0.5, y: CCDirector.sharedDirector().viewSize().height * 0.5)
        let moveMessage = CCActionMoveTo(duration: 0.3, position: messagePos)
        tutorialMessage3.position = CGPoint(x: CCDirector.sharedDirector().viewSize().width * -0.50, y: CCDirector.sharedDirector().viewSize().height * 0.5)
        tutorialMessage3.runAction(moveMessage)
        NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("endTutorialPhase4"), userInfo: nil, repeats: false)
    }
    
    func endTutorialPhase4() {
        let messagePos = CGPoint(x: CCDirector.sharedDirector().viewSize().width * 1.5, y: CCDirector.sharedDirector().viewSize().height * 0.5)
        let moveMessage = CCActionMoveTo(duration: 0.3, position: messagePos)
        tutorialMessage3.runAction(moveMessage)
        tutorialPhase = .Phase5
    }
    
    func startTutorialPhase5() {
        holdIcon = CCBReader.load("HoldIcon")
        tutorialTeaNode.addChild(holdIcon)
        let messagePos = CGPoint(x: CCDirector.sharedDirector().viewSize().width * 0.5, y: CCDirector.sharedDirector().viewSize().height * 0.5)
        let moveMessage = CCActionMoveTo(duration: 0.3, position: messagePos)
        tutorialMessage4.position = CGPoint(x: CCDirector.sharedDirector().viewSize().width * -0.50, y: CCDirector.sharedDirector().viewSize().height * 0.5)
        tutorialMessage4.runAction(moveMessage)
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("endTutorialPhase5"), userInfo: nil, repeats: false)
        
    }
    
    func endTutorialPhase5() {
        holdIcon?.removeFromParent()
        let messagePos = CGPoint(x: CCDirector.sharedDirector().viewSize().width * 1.5, y: CCDirector.sharedDirector().viewSize().height * 0.5)
        let moveMessage = CCActionMoveTo(duration: 0.3, position: messagePos)
        tutorialMessage4.runAction(moveMessage)
        tutorialPhase = .Phase6
    }
    
    func startTutorialPhase6() {
        tapArrowTea = CCBReader.load("TapArrow")
        tutorialTeaNode.addChild(tapArrowTea)
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("boilTea"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("serveTea"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(4.5, target: self, selector: Selector("endTutorialPhase6"), userInfo: nil, repeats: false)

    }
    
    func endTutorialPhase6() {
        tapArrowTea?.removeFromParent()
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("endTutorial"), userInfo: nil, repeats: false)

    }
    
    func pushBox1() {
        tapArrow1!.animationManager.runAnimationsForSequenceNamed("Tap")
        dishNode1.serveDish1()
    }
    
    func pushBox2() {
        tapArrow2!.animationManager.runAnimationsForSequenceNamed("Tap")
        dishNode2.serveDish2()
    }
    
    func pushBox3() {
        tapArrow3!.animationManager.runAnimationsForSequenceNamed("Tap")
        dishNode3.serveDish3()
    }

    func pushBox4() {
        tapArrow4!.animationManager.runAnimationsForSequenceNamed("Tap")
        dishNode4.serveDish4()
    }
    
    func serveCustomer() {
        tapArrow5!.animationManager.runAnimationsForSequenceNamed("Tap")
        serve()
    }
    
    func boilTea() {
        tapArrowTea!.animationManager.runAnimationsForSequenceNamed("Hold")
        tea?.animationManager.runAnimationsForSequenceNamed("BoilTea")
        
    }
    
    func serveTea() {
        tapArrowTea!.animationManager.runAnimationsForSequenceNamed("Start")
        tea?.animationManager.runAnimationsForSequenceNamed("ServeTea")
    }
    
    func endTutorial() {
        NSNotificationCenter.defaultCenter().removeObserver(self)

        let mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainScene, withTransition: fadeTransition)
    }
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    
    func gameover() {
        
        if gameDifficulty == .Easy {
            
            mixpanel.track("Level Completed", properties: ["Score": payout, "Difficulty": "Easy", "Total Time": totalTimer])
            
            if payout > persistentData.highScoreEasy {
                persistentData.highScoreEasy = payout

            }
        }
        
        if gameDifficulty == .Hard {
            
            mixpanel.track("Level Completed", properties: ["Score": payout, "Difficulty": "Hard", "Total Time": totalTimer])
            
            if payout > persistentData.highScoreHard {
                persistentData.highScoreHard = payout
            }
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self)

        gameRetryButton.visible = false
        menuButton.visible = false
        serveButton.visible = false
        timeLeftLabel.string = String(0)
        var gameOverScreen = CCBReader.load("GameOver", owner: self) as! GameOver
        
        plate!.zOrder -= 2
        
        if gameDifficulty == .Easy {
            
            gameOverScreen.setResults(payout, high: persistentData.highScoreEasy, time: totalTimer, tea: teaServed, dishes: dishesServed, perfect: perfectOrders)
        }
        
        if gameDifficulty == .Hard {
            
            gameOverScreen.setResults(payout, high: persistentData.highScoreHard, time: totalTimer, tea: teaServed, dishes: dishesServed, perfect: perfectOrders)
        }
        
        let gameOverScreenPos = CGPoint(x: CCDirector.sharedDirector().viewSize().width / 2, y: CCDirector.sharedDirector().viewSize().height * 2)
        let gameOverPos = CGPoint(x: CCDirector.sharedDirector().viewSize().width * 0.5, y: CCDirector.sharedDirector().viewSize().height * 0.5)
        let moveGameOver = CCActionMoveTo(duration: 1, position: gameOverPos)
        let bounceGameOver = CCActionEaseBackOut(action: moveGameOver)
        
        gameOverScreen.position = gameOverScreenPos
        gameOverScreen.runAction(bounceGameOver)

        self.addChild(gameOverScreen)
        gameState = .Gameover
        
    } // gameover()
    
    func menuGO(notification: NSNotification) {
        menu()
    }
    
    func spawnCustomer() {
        
        var spawnRandomizer = CCRANDOM_0_1() * 10
        
        //customer = CCBReader.load("Customer2") as? Customer
        
        if spawnRandomizer < 6 {
            
            customer = CCBReader.load("Customer") as? Customer
            
        } else if spawnRandomizer < 10 {
            
            customer = CCBReader.load("Customer2") as? Customer
            
        }
        //else if spawnRandomizer < 10 {
//
//            customer = CCBReader.load("foodCritic") as? Customer
//            
//        }
        
        customerNode.addChild(customer)
        patienceLevel = customer!.patience
        patienceLeft = customer!.patience
        
        if gameDifficulty == .Tutorial {
            customer!.setTutorialOrder()
        }
        else {
            customer!.setOrder()
        }

        orderCount1 = customer!.order1
        orderCount2 = customer!.order2
        orderCount3 = customer!.order3
        orderCount4 = customer!.order4

        totalOrderCount = orderCount1 + orderCount2 + orderCount3 + orderCount4
        serveButton.zOrder += 1
        payPerfect = customer!.payPerfect
        payGood = customer!.payGood
        payBad = customer!.payBad
        
        
        if difficultyScale == .Medium {
            scalePatience(0.95)
            scalePayBonus(1.2)
            
        }
        
        if difficultyScale == .Hard {
            scalePatience(0.9)
            scalePayBonus(1.5)
            scaleTimeBonus(0.9)
        }
        
        if difficultyScale == .Insane {
            scalePatience(0.87)
            scalePayBonus(1.7)
            scaleTimeBonus(0.8)
        }
        
        if difficultyScale == .Impossible {
            scalePatience(0.85)
            scalePayBonus(2)
            scaleTimeBonus(0.7)
        }
        
        if difficultyScale == .God {
            scalePatience(0.82)
            scalePayBonus(3)
            scaleTimeBonus(0.65)
        }
        
        if gameDifficulty == .Easy {
            scalePatience(1.8)
        }

        plate = CCBReader.load("Plate") as? Plate

        let messagePos = CGPoint(x: CCDirector.sharedDirector().viewSize().width * 0.5, y: CCDirector.sharedDirector().viewSize().height * 0.45)
        plate!.position = messagePos
        
        self.addChild(plate)

    } // spawnCustomer()
    
    func scalePayBonus(scalar: Float) {
        payPerfect = Int(Float(payPerfect) * scalar)
        payGood = Int(Float(payGood) * scalar)
        payBad = Int(Float(payBad) * scalar)
    }
    
    func scaleTimeBonus(scalar: Float) {
        timePerfect *= scalar
        timeGood *= scalar
        timeBad *= scalar
    }
    
    func scalePatience(scalar: Float) {
        patienceLevel *= scalar
        patienceLeft *= scalar
    }
    
    func resetCombo() {
        
        comboCounter = 0
        
        for coin in combo {
            coin.visible = false
        }
        
    } // resetCombo()
    
    func reset() {
        currentOrders = 0
        servingCount1 = 0
        servingCount2 = 0
        servingCount3 = 0
        servingCount4 = 0
        
    } // reset()
    
    func retry() {
        var easyDifficulty = false
        
        if gameDifficulty == .Easy {
            easyDifficulty = true
        }
        
        let gameplayScene = CCBReader.load("Gameplay") as! Gameplay
        let replayScene = CCScene()
        
        if easyDifficulty == true {
            gameplayScene.gameDifficulty = .Easy
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self)

        replayScene.addChild(gameplayScene)
        CCDirector.sharedDirector().presentScene(replayScene)

        gameState = .Playing
        difficultyScale = .Easy
        
    } // retry selector
    
    
    
    func serve() {
        
        let squish = CCActionScaleTo(duration: 0.1, scale: 0.4)
        let unsquish = CCActionScaleTo(duration: 0.1, scale: 1)
        let seq = CCActionSequence(array: [squish, unsquish])
        
        register.runAction(seq)
        timer.runAction(seq)
        
        tapWarning = false
        
        if let customerTapIco = customerTapIcon {
            customerTapIco.removeFromParent()
        }
        
        let platePos = CGPoint(x: CCDirector.sharedDirector().viewSize().width / 2, y: CCDirector.sharedDirector().viewSize().height * 0.5)
        let servePlate = CCActionMoveTo(duration: 0.2, position: platePos)
        let scalePlate = CCActionScaleBy(duration: 0.2, scale: 0.7)
        plate!.runAction(scalePlate)
        plate!.runAction(servePlate)
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("deallocPlate"), userInfo: nil, repeats: false)
 
        isBadOrder = false
        
        totalServingCount = servingCount1 + servingCount2 + servingCount3 + servingCount4
        
        if abs(totalOrderCount - totalServingCount) >= accuracyBad {
            
            // dissatisfied expression here
            isBadOrder = true
            NSNotificationCenter.defaultCenter().postNotificationName("bad order", object: nil)
            return
        }
        
        dishesServed++
        
        if let coinVar = coin {
            coinVar.removeFromParent()
        }

        if servingCount1 == orderCount1 && servingCount2 == orderCount2 && servingCount3 == orderCount3 && servingCount4 == orderCount4 {
            
            perfectOrders++
            payIncrease = payPerfect
            payout += payPerfect
            payoutLabel.string = String(payout)
            timeLeft += timePerfect
            timeBonus = timePerfect
            
            
            
            // next update stuff
//            if comboCounter != 3 {
//                
//                combo[comboCounter].visible = true
//            }
            
            //comboCounter++
            
//            if comboCounter == 4 {
//                
//                payIncrease = comboBonus
//                payout += comboBonus
//                payoutLabel.string = String(payout)
//                resetCombo()
//                
//            }
            
        } else if abs(totalOrderCount - totalServingCount) < accuracyGood {
            
            // happy customer animation here
            payIncrease = payGood
            payout += payGood
            timeLeft += timeGood
            timeBonus = timeGood
            payoutLabel.string = String(payout)
            
        } else if abs(totalOrderCount - totalServingCount) < accuracyBad {
            
            // horrified customer expression animation here
            payIncrease = payBad
            payout += payBad
            timeLeft += timeBad
            timeBonus = timeBad
            payoutLabel.string = String(payout)


            
        } 
        
        
        //customer leave animation here
        
        //money flying animation here
        
    } // serve selector
    
    
    
    func deallocPlate() {
        
        // deallocates the plate after served
        
            plate!.removeFromParent()
            customer!.removeFromParent()
            
            //reset labels
            reset()
        
        spawnCustomer()

    }
    
    func menu() {
        
        // button selector that returns user back to the menu scene
        
        NSNotificationCenter.defaultCenter().removeObserver(self)

        let menuScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(menuScene)
        
    }
    
    
    //selectors
    
    func serveDish1(notification: NSNotification) {
        
        servingCount1++
        currentOrders++

        //serving1.string = String(servingCount1)
        customer!.order1 -= 1
        customer!.orderLabel1.string = String(customer!.order1)
        updatePlateSprite()
        
    }
    
    func serveDish2(notification: NSNotification) {
        
        servingCount2++
        currentOrders++
        //serving2.string = String(servingCount2)
        customer!.order2 -= 1
        customer!.orderLabel2.string = String(customer!.order2)
        updatePlateSprite()
        
    }
    
    func serveDish3(notification: NSNotification) {
        
        servingCount3++
        currentOrders++

        //serving3.string = String(servingCount3)
        customer!.order3 -= 1
        customer!.orderLabel3.string = String(customer!.order3)
        updatePlateSprite()

    }
    
    func serveDish4(notification: NSNotification) {
        
        servingCount4++
        currentOrders++

        //serving4.string = String(servingCount4)
        customer!.order4 -= 1
        customer!.orderLabel4.string = String(customer!.order4)
        updatePlateSprite()

    }
    
    func serveTea(notification: NSNotification) {
        
        teaServed++
        payIncrease = teaBonus
        timeBonus = 0.5
        timeLeft += timeBonus
        payout += teaBonus
        payoutLabel.string = String(payout)

    }
    
    func updatePlateSprite() {
        
        
        if currentOrders == 1 {
            plate!.animationManager.runAnimationsForSequenceNamed("plate1 timeline")
        }
        if currentOrders == 2 {
            plate!.animationManager.runAnimationsForSequenceNamed("plate2 timeline")
        }
        if currentOrders == 3 {
            plate!.animationManager.runAnimationsForSequenceNamed("plate3 timeline")
        }
        if currentOrders == 6 {
            plate!.animationManager.runAnimationsForSequenceNamed("small timeline")
        }
        if currentOrders == 8 {
            plate!.animationManager.runAnimationsForSequenceNamed("medium timeline")
        }
        if currentOrders == 10 {
            plate!.animationManager.runAnimationsForSequenceNamed("large timeline")
        }
        
    }

    

    
}

// leaderboard not working
// get it done for next update

extension Gameplay: GKGameCenterControllerDelegate {
    func showLeaderboard() {
        var viewController = CCDirector.sharedDirector().parentViewController!
        var gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    // Delegate methods
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func openGameCenter() {
        showLeaderboard()
    }
    
    
}



