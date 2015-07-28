//
//  Gameplay.swift
//  Bento
//
//  Created by Peter Cho on 7/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//  320x568

import UIKit

enum DifficultyScale {
    case Easy
    case Medium
    case Hard
}

enum GameDifficulty {
    case Easy
    case Hard
}

enum GameState {
    case Playing
    case Frenzy
    case Gameover
}

class Gameplay: CCScene, CCPhysicsCollisionDelegate {
    
    // MARK: variables
    
    // Code connections
    
    var coin: CCNode!
    
    // Four main input buttons + rice + tea
    weak var button1: CCButton!
    weak var button2: CCButton!
    weak var button3: CCButton!
    weak var button4: CCButton!
    weak var serveTeaButton: CCButton!
    
    // score label
    weak var payoutLabel: CCLabelTTF!
    
    // invisible button over the customer to serve
    weak var serveButton: CCButton!
    
    // retry button once the day finishes
    weak var retryButton: CCButton!
    
    // meter for the customer patience level
    weak var lifeBar: CCSprite!
    
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
    let timePerfect: Float = 3
    let timeGood: Float = 2
    let timeBad: Float = 1
    
    // Total time of the day
    var totalTime: Float = 30
    var totalTimer: Float = 0
    
    // Customer variables
    var customer: Customer?
    
    // bonuses
    var teaBonus = 500
    var comboBonus = 300
    
    // Accuracy threshold for different amounts of points system
    let accuracyGood = 2
    let accuracyBad = 4

    // Variables for tip combo
    var combo: [CCSprite] = []
    var comboCounter = 0
    
    // Order variables from the customer
    var orderCount1 = 0
    var orderCount2 = 0
    var orderCount3 = 0
    var orderCount4 = 0
    var totalOrderCount = 0
    
    // Serving input variables
    var servingCount1 = 0
    var servingCount2 = 0
    var servingCount3 = 0
    var servingCount4 = 0
    var totalServingCount = 0
    
    // animation timers
    var isBadOrder = false
    var badOrderTimer: Float = 0
    var badOrderTime: Float = 2
    
    // Game over node
    weak var gameOverNode: CCNode!
    
    // Game Over stats
    var teaServed = 0
    var dishesServed = 0
    var perfectOrders = 0
    
    // Customer payout distribution variables
    var payIncrease = 0
    var payPerfect = 0
    var payGood = 0
    var payBad = 0
    var payout = 0 {
        didSet {
            scoreBonusLabel.string = String(payIncrease)
            scoreBonusLabel.visible = true
            scorePlusLabel.visible = true
            timeBonusLabel.string = String(stringInterpolationSegment: timeBonus)
            timeBonusLabel.visible = true
            timePlusLabel.visible = true
        }
    }
    
    // score and time bonus labels and timer
    var bonusTimer: Float = 0
    weak var timePlusLabel: CCLabelTTF!
    weak var timeBonusLabel: CCLabelTTF!
    weak var scorePlusLabel: CCLabelTTF!
    weak var scoreBonusLabel: CCLabelTTF!
    
    // Gamestate enum
    var gameState: GameState = .Playing
    
    // Game difficulty enum and times
    var gameDifficulty: GameDifficulty = .Easy
    var mediumTime: Float = 13
    var hardTime: Float = 23
    
    // Difficulty customer scaling based on time left
    var difficultyScale: DifficultyScale = .Easy
    
    // Customer patience level variable with accordingly adjusted timer
    var patienceLevel: Float = 1
    var patienceLeft: Float = 0 {
        didSet {
            patienceLeft = max(min(patienceLeft, patienceLevel), 0)
            lifeBar.scaleX = patienceLeft / Float(patienceLevel) * 0.7
        }
    }
    
    
    // play any openning animations
    func didLoadFromCCB() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "serveDish1:", name:"dish1 served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "serveDish2:", name:"dish2 served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "serveDish3:", name:"dish3 served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "serveDish4:", name:"dish4 served", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "serveTea:", name:"tea done", object: nil)

        timeLeft = totalTime
        combo = [bonusFish1, bonusFish2, bonusFish3]
        userInteractionEnabled = true
        spawnCustomer()
        
    } // didLoadFromCCB()
    
    override func update(delta: CCTime) {

        if gameState == .Playing {
            timeLeft -= Float(delta)
            timeLeftLabel.string = String(Int(timeLeft))
            patienceLeft -= Float(delta)
            totalTimer += Float(delta)
        
            if totalTimer > mediumTime {
                difficultyScale = .Medium
            }
        
            else if totalTimer > hardTime {
                difficultyScale = .Hard
            }
        
            if patienceLeft == 0 {
                // customer disgusted animation and leave
                //deallocating the different customers
                if let customerVar = customer {
                    customerVar.removeFromParent()
                }

                reset()
                spawnCustomer()
            }
        
            if scoreBonusLabel.visible == true {
                bonusTimer += Float(delta)
            }
        
            if bonusTimer > 0.5 {
                scoreBonusLabel.visible = false
                scorePlusLabel.visible = false
                timePlusLabel.visible = false
                timeBonusLabel.visible = false
                bonusTimer = 0
            }
            
            if isBadOrder == true {
                badOrderTimer += Float(delta)
                if badOrderTimer > badOrderTime {
                    isBadOrder = false
                    badOrderTimer = 0
                    customer!.removeFromParent()
                    reset()
                    spawnCustomer()
                }
            }
        
            if timeLeft <= 0 {
                gameover()
            }
        }
    } // update loop
    
    func gameover() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self) // Remove from all notifications being observed
        serveButton.visible = false
        timeLeftLabel.string = String(0)
        var gameOverScreen = CCBReader.load("GameOver", owner: self) as! GameOver
        gameOverScreen.setResults(payout, time: totalTimer, tea: teaServed, dishes: dishesServed, perfect: perfectOrders)
        gameOverNode.addChild(gameOverScreen)
        gameState = .Gameover
        
    } // gameover()
    
    func spawnCustomer() {
        
//        var spawnRandomizer = CCRANDOM_0_1() * 10
//        
//        if spawnRandomizer < 4.5 {
//            
//            customer = CCBReader.load("Customer") as? Customer
//            
//        } else if spawnRandomizer < 9 {
//            
//            customer = CCBReader.load("Customer2") as? Customer
//            
//        } else if spawnRandomizer < 10 {
//            
//            customer = CCBReader.load("foodCritic") as? Customer
//            
//        }
        
        customer = CCBReader.load("Customer") as? Customer

        
        customerNode.addChild(customer)
        patienceLevel = customer!.patience
        patienceLeft = customer!.patience
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
            patienceLevel -= 0.7
            patienceLeft -= 0.7
            payPerfect = Int(Double(payPerfect) * 1.2)
            payGood = Int(Double(payGood) * 1.2)
            payBad = Int(Double(payBad) * 1.2)
        }
        
        if difficultyScale == .Hard {
            patienceLevel -= 1.2
            patienceLeft -= 1.2
            payPerfect = Int(Double(payPerfect) * 1.5)
            payGood = Int(Double(payGood) * 1.5)
            payBad = Int(Double(payBad) * 1.5)
        }


    } // spawnCustomer()
    
    func resetCombo() {
        
        comboCounter = 0
        
        for coin in combo {
            coin.visible = false
        }
        
    } // resetCombo()
    
    func reset() {
        
        servingCount1 = 0
        servingCount2 = 0
        servingCount3 = 0
        servingCount4 = 0
        
    } // reset()
    
    func retry() {
        
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
        gameState = .Playing
        difficultyScale = .Easy
        
    } // retry selector
    
    func serve() {
        
        isBadOrder = false
        
        totalServingCount = servingCount1 + servingCount2 + servingCount3 + servingCount4
        
        if abs(totalOrderCount - totalServingCount) >= accuracyBad {
            
            // dissatisfied expression here
            isBadOrder = true
            NSNotificationCenter.defaultCenter().postNotificationName("bad order", object: nil)

        }
        
        dishesServed++
        
        if let coinVar = coin {
            coinVar.removeFromParent()
        }
        
        // if the order is matched perfectly
        // happy customer animation here
        if servingCount1 == orderCount1 && servingCount2 == orderCount2 && servingCount3 == orderCount3 && servingCount4 == orderCount4 {
            
            perfectOrders++
            payIncrease = payPerfect
            payout += payPerfect
            payoutLabel.string = String(payout)
            timeLeft += timePerfect
            timeBonus = timePerfect
            
            if comboCounter != 3 {
                
                combo[comboCounter].visible = true
            }
            
            comboCounter++
            
            if comboCounter == 4 {
                
                payIncrease = comboBonus
                payout += comboBonus
                payoutLabel.string = String(payout)
                resetCombo()
                
            }
            
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
        coin = CCBReader.load("Coin", owner: self)
        
        //money flying animation here
        serveButton.addChild(coin!)
        
        //deallocating the different customers
        if isBadOrder == false {
            customer?.removeFromParent()
        
            //reset labels
            reset()
        
            //spawn new customer after leave animation
            spawnCustomer()
        }
    } // serve selector
    
    func serveRice() {
        
    } // serveRice selector
    
    func serveDish1(notification: NSNotification) {
        
        servingCount1++
        //serving1.string = String(servingCount1)
        customer!.order1 -= 1
        customer!.orderLabel1.string = String(customer!.order1)
        
    }
    
    func serveDish2(notification: NSNotification) {
        
        servingCount2++
        //serving2.string = String(servingCount2)
        customer!.order2 -= 1
        customer!.orderLabel2.string = String(customer!.order2)
        
    }
    
    func serveDish3(notification: NSNotification) {
        
        servingCount3++
        //serving3.string = String(servingCount3)
        customer!.order3 -= 1
        customer!.orderLabel3.string = String(customer!.order3)

    }
    
    func serveDish4(notification: NSNotification) {
        
        servingCount4++
        //serving4.string = String(servingCount4)
        customer!.order4 -= 1
        customer!.orderLabel4.string = String(customer!.order4)

    }
    
    func serveTea(notification: NSNotification) {
        
        teaServed++
        payIncrease = teaBonus
        timeBonus = 0.5
        timeLeft += timeBonus
        payout += teaBonus
        payoutLabel.string = String(payout)

    }
    
}
