//
//  GameScene.swift
//  Project8
//
//  Created by Jinwoo Kim on 2/12/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let startNewGame = ButtonNode(imageNamed: "startNewGameLo")
    let howToPlay = ButtonNode(imageNamed: "howToPlayLo")
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        let title = SKSpriteNode(imageNamed: "blastazapTitle")
        title.position = CGPoint(x: 0, y: 200)
        addChild(title)
        
        let strap = SKSpriteNode(imageNamed: "strap")
        strap.position = CGPoint(x: 0, y: 50)
        addChild(strap)
        
        //
        
        startNewGame.setFocusedImage(named: "startNewGameHi")
        startNewGame.position = CGPoint(x: 0, y: -100)
        addChild(startNewGame)
        
        howToPlay.setFocusedImage(named: "howToPlayHi")
        howToPlay.position = CGPoint(x: 0, y: -250)
        addChild(howToPlay)
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let previous = context.previouslyFocusedItem as? ButtonNode {
            previous.didLoseFocus()
        }
        
        if let next = context.nextFocusedItem as? ButtonNode {
            next.didGainFocus()
        }
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let selected = UIScreen.main.focusedItem else { return }
        guard let press = presses.first else { return }
        
        if press.type == .select {
            if selected === startNewGame {
                let game = PlayScene(size: size)
                let transition = SKTransition.doorsOpenVertical(withDuration: 1)
                view?.presentScene(game, transition: transition)
            }
        }
    }
}
