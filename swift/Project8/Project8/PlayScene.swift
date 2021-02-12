//
//  PlayScene.swift
//  Project8
//
//  Created by Jinwoo Kim on 2/12/21.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case playerWeapon = 2
    case enemy = 4
    case enemyWeapon = 8
}

class PlayScene: SKScene {
    let player = SKSpriteNode(imageNamed: "player")
    
    let levelWaves: [EnemyWave] = [.smallSmall, .mediumSmall, .smallSmall, .largeSmall, .flurrySmall, .smallMedium, .mediumMedium, .largeMedium, .largeSmall, .mediumMedium, .smallLarge, .largeSmall, .largeLarge]
    var levelPosition = 0
    
    let enemyOffsetX: CGFloat = 100
    static let enemyStartX = 1100

    let positions = [
        CGPoint(x: enemyStartX, y: 400),
        CGPoint(x: enemyStartX, y: 300),
        CGPoint(x: enemyStartX, y: 200),
        CGPoint(x: enemyStartX, y: 100),
        CGPoint(x: enemyStartX, y: 0),
        CGPoint(x: enemyStartX, y: -100),
        CGPoint(x: enemyStartX, y: -200),
        CGPoint(x: enemyStartX, y: -300),
        CGPoint(x: enemyStartX, y: -400)
    ]
    
    var playerIsAlive = true
    
    var scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    let music = SKAudioNode(fileNamed: "cyborgNinja.mp3")
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.zPosition = -2
        background.blendMode = .replace
        addChild(background)
        
        if let particles = SKEmitterNode(fileNamed: "starfield") {
            particles.position = CGPoint(x: 1080, y: 0)
            // 60초가 된 시점의 프레임부터 보여준다.
            particles.advanceSimulationTime(60)
            addChild(particles)
        }
        
        player.name = "player"
        player.position.x = -700
        player.zPosition = 1
        addChild(player)
        
        //
        
        // create a physics body for the player using its texture at its current size
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        
        // make this as being the player
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        
        // tell it to bounce off enemies and enemy weapon
        player.physicsBody?.collisionBitMask = CollisionTypes.enemy.rawValue | CollisionTypes.enemyWeapon.rawValue
        
        // ask SpriteKit to tell us when it collides with enemies and their weapons
        player.physicsBody?.contactTestBitMask = CollisionTypes.enemy.rawValue | CollisionTypes.enemyWeapon.rawValue
        
        physicsWorld.gravity = .zero
        
        physicsWorld.contactDelegate = self
        
        //
        
        scoreLabel.position = CGPoint(x: 0, y: 400)
        scoreLabel.zPosition = -1
        scoreLabel.fontSize = 96
        addChild(scoreLabel)
        score = 0
        
        //
        
        addChild(music)
    }
    
    func movePlayer(_ delta: CGPoint) {
        player.position.y -= delta.y * 2
        
        if player.position.y < -500 {
            player.position.y = -500
        } else if player.position.y > 500 {
            player.position.y = 500
        }
    }
    
    func createWave() {
        guard playerIsAlive else { return }
        guard levelPosition < levelWaves.count else { return }

        switch levelWaves[levelPosition] {
        case .smallSmall:
            addChild(EnemyNode(type: "enemy1", startPosition: positions[0], xOffset: enemyOffsetX * 2, moveStraight: true))
            addChild(EnemyNode(type: "enemy1", startPosition: positions[4], xOffset: 0, moveStraight: true))
            addChild(EnemyNode(type: "enemy1", startPosition: positions[8], xOffset: enemyOffsetX * 2, moveStraight: true))

        case .mediumSmall:
            addChild(EnemyNode(type: "enemy1", startPosition: positions[2], xOffset: 0, moveStraight: false))
            addChild(EnemyNode(type: "enemy1", startPosition: positions[1], xOffset: enemyOffsetX * 2, moveStraight: false))
            addChild(EnemyNode(type: "enemy1", startPosition: positions[0], xOffset: enemyOffsetX * 4, moveStraight: false))

            addChild(EnemyNode(type: "enemy1", startPosition: positions[6], xOffset: enemyOffsetX, moveStraight: false))
            addChild(EnemyNode(type: "enemy1", startPosition: positions[7], xOffset: enemyOffsetX * 3, moveStraight: false))
            addChild(EnemyNode(type: "enemy1", startPosition: positions[8], xOffset: enemyOffsetX * 5, moveStraight: false))

        case .largeSmall:
            addChild(EnemyNode(type: "enemy1", startPosition: positions[4], xOffset: 0, moveStraight: true))

            addChild(EnemyNode(type: "enemy1", startPosition: positions[3], xOffset: enemyOffsetX, moveStraight: true))
            addChild(EnemyNode(type: "enemy1", startPosition: positions[2], xOffset: enemyOffsetX * 2, moveStraight: true))
            addChild(EnemyNode(type: "enemy1", startPosition: positions[1], xOffset: enemyOffsetX * 3, moveStraight: true))

            addChild(EnemyNode(type: "enemy1", startPosition: positions[5], xOffset: enemyOffsetX, moveStraight: true))
            addChild(EnemyNode(type: "enemy1", startPosition: positions[6], xOffset: enemyOffsetX * 2, moveStraight: true))
            addChild(EnemyNode(type: "enemy1", startPosition: positions[7], xOffset: enemyOffsetX * 3, moveStraight: true))

            addChild(EnemyNode(type: "enemy1", startPosition: positions[2], xOffset: enemyOffsetX * 8, moveStraight: false))
            addChild(EnemyNode(type: "enemy1", startPosition: positions[1], xOffset: enemyOffsetX * 8, moveStraight: false))
            addChild(EnemyNode(type: "enemy1", startPosition: positions[0], xOffset: enemyOffsetX * 8, moveStraight: false))

            addChild(EnemyNode(type: "enemy1", startPosition: positions[6], xOffset: enemyOffsetX * 9, moveStraight: false))
            addChild(EnemyNode(type: "enemy1", startPosition: positions[7], xOffset: enemyOffsetX * 9, moveStraight: false))
            addChild(EnemyNode(type: "enemy1", startPosition: positions[8], xOffset: enemyOffsetX * 9, moveStraight: false))

        default:
            let randomPositions = positions.shuffled()

            for (index, position) in randomPositions.enumerated() {
                addChild(EnemyNode(type: "enemy1", startPosition: position, xOffset: enemyOffsetX * CGFloat(index * 3), moveStraight: true))
            }
        }
        
        levelPosition += 1
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        for child in children {
            if child.frame.maxX < 0 {
                if !frame.intersects(child.frame) {
                    child.removeFromParent()
                }
            }
        }
        
        let enemies = children.compactMap { $0 as? EnemyNode }
        
        if enemies.isEmpty {
            createWave()
        }
        
        //
        
        for enemy in enemies {
            if enemy.lastFireTime + 1 < currentTime {
                enemy.lastFireTime = currentTime
                if Bool.random() {
                    enemy.fire()
                }
            }
        }
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard playerIsAlive else { return }
        guard let press = presses.first else { return }
        
        // check that the player pressed the play button
        if press.type == .playPause {
            // create a weapon
            let shot = SKSpriteNode(imageNamed: "playerWeapon")
            shot.name = "playerWeapon"
            
            // make it start from the player's position
            shot.position = player.position
            
            // give it rectangular physics
            shot.physicsBody = SKPhysicsBody(rectangleOf: shot.size)
            shot.physicsBody?.categoryBitMask = CollisionTypes.playerWeapon.rawValue
            shot.physicsBody?.contactTestBitMask = CollisionTypes.enemy.rawValue
            shot.physicsBody?.collisionBitMask = CollisionTypes.enemy.rawValue
            addChild(shot)
            
            // tell it to move to the other side of the screen then destroy itself
            let movement = SKAction.move(to: CGPoint(x: 1900, y: shot.position.y), duration: 1)
            let sequence = SKAction.sequence([movement, SKAction.removeFromParent()])
            
            // run it immediately
            shot.run(sequence)
            
            score -= 1
            
            //
            
            run(SKAction.playSoundFileNamed("playerWeapon.wav", waitForCompletion: false))
        }
    }
    
    func gameOver() {
        playerIsAlive = false
        
        if let explosion = SKEmitterNode(fileNamed: "explosion") {
            explosion.position = player.position
            addChild(explosion)
        }
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        addChild(gameOver)
        
        music.run(SKAction.stop())
    }
    
    func quitGame() {
        let menu = GameScene(size: size)
        menu.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let transition = SKTransition.doorsCloseVertical(withDuration: 1)
        view?.presentScene(menu, transition: transition)
        
        // tell the root view controller to update its focus
        menu.run(SKAction.wait(forDuration: 0.1)) {
            menu.view?.window?.rootViewController?.setNeedsFocusUpdate()
        }
    }
}

extension PlayScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // make sure node colliding objects have SpriteKit nodes attached
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        // if either node was the player, the game is over
        if nodeA.name == "player" || nodeB.name == "player" {
            guard playerIsAlive else { return }
            gameOver()
        } else {
            // create an explosion
            if let explosion = SKEmitterNode(fileNamed: "explosion") {
                // if the first object is the player weapon
                if nodeA.name == "playerWeapon" {
                    // position the explosion over the other object
                    explosion.position = nodeB.position
                } else {
                    // otherwise position the object over the first object
                    explosion.position = nodeA.position
                }
                
                run(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false))
                
                // add the explosion to the game
                addChild(explosion)
                
                score += 10
            }
        }
        
        nodeA.removeFromParent()
        nodeB.removeFromParent()
    }
}
