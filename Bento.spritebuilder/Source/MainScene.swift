import Foundation

class MainScene: CCNode {
    
    weak var titlePlayButton: CCButton!
    weak var titleTutorialButton: CCButton!
    var fadeTransition: CCTransition = CCTransition(fadeWithDuration: 1)
    
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

}
