import Foundation

class MainScene: CCNode {
    
    weak var titlePlayButton: CCButton!
    weak var titleTutorialButton: CCButton!
    var fadeTransition: CCTransition = CCTransition(fadeWithDuration: 1)
    var creditsLayer: CCNode?
    
    func didLoadFromCCB() {
        setUpGameCenter()
    }
    
    func play() {
        
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene, withTransition: fadeTransition)
        
    }
    
    func playEasy() {
        
        let easyGameplayScene = CCScene()
        let gameplayScene = CCBReader.load("Gameplay") as! Gameplay
        
        easyGameplayScene.addChild(gameplayScene)
        gameplayScene.gameDifficulty = .Easy
        CCDirector.sharedDirector().presentScene(easyGameplayScene, withTransition: fadeTransition)

        
    }
    
    func tutorial() {
        let tutorialScene = CCScene()
        let gameplayScene = CCBReader.load("Gameplay") as! Gameplay
        tutorialScene.addChild(gameplayScene)
        gameplayScene.gameDifficulty = .Tutorial
        CCDirector.sharedDirector().presentScene(tutorialScene, withTransition: fadeTransition)
    }
    
    func credits() {
        creditsLayer = CCBReader.load("Credits", owner: self)
        let credPos = CGPoint(x: CCDirector.sharedDirector().viewSize().width * 0.5, y: CCDirector.sharedDirector().viewSize().height * 0.5)
        let moveCreds = CCActionMoveTo(duration: 0.3, position: credPos)
        creditsLayer!.position = CGPoint(x: CCDirector.sharedDirector().viewSize().width * 1.5, y: CCDirector.sharedDirector().viewSize().height * 0.5)
        self.addChild(creditsLayer)
        creditsLayer?.runAction(moveCreds)
    }
    
    func back() {
        let credPos = CGPoint(x: CCDirector.sharedDirector().viewSize().width * 1.5, y: CCDirector.sharedDirector().viewSize().height * 0.5)
        let moveCreds = CCActionMoveTo(duration: 0.3, position: credPos)
        creditsLayer?.runAction(moveCreds)
        NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("deallocCreds"), userInfo: nil, repeats: false)
    }
    
    func deallocCreds() {
        creditsLayer?.removeFromParent()

    }
    
    func setUpGameCenter() {
        let gameCenterInteractor = GameCenterInteractor.sharedInstance
        gameCenterInteractor.authenticationCheck()
    }

}
