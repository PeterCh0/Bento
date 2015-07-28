import Foundation

class MainScene: CCNode {
    
    weak var titlePlayButton: CCButton!
    weak var titleTutorialButton: CCButton!
    
    func play() {
        
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
        
    }
    
    func playEasy() {
        
        let easyGameplayScene = CCScene()
        let gameplayScene = CCBReader.load("Gameplay") as! Gameplay
        
        easyGameplayScene.addChild(gameplayScene)
        gameplayScene.teaBonus = 600
        CCDirector.sharedDirector().presentScene(easyGameplayScene)

        
    }

}
