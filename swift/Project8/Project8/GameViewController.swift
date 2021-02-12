//
//  GameViewController.swift
//  Project8
//
//  Created by Jinwoo Kim on 2/12/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var gameScene: SKScene? {
        return (self.view as! SKView).scene
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
            let recognizer = UIPanGestureRecognizer(target: self, action: #selector(movementMade))
            view.addGestureRecognizer(recognizer)
        }
    }

    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let press = presses.first else { return }
        
        if press.type == .menu {
            if let scene = gameScene as? PlayScene {
                scene.quitGame()
            } else {
                super.pressesBegan(presses, with: event)
            }
        }
        
        gameScene?.pressesBegan(presses, with: event)
    }
    
    @objc func movementMade(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: recognizer.view)
        recognizer.setTranslation(.zero, in: recognizer.view)
        
        if let scene = gameScene as? PlayScene {
            scene.movePlayer(translation)
        }
    }
}
