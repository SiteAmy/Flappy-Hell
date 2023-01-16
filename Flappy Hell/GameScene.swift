//
//  GameScene.swift
//  Flappy Hell
//
//  Created by Amy Nijmeijer on 22/11/2022.
//

import Foundation
import SpriteKit
import GameplayKit

enum GameSceneState {
    case active, gameOver
}







class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var playerShip: SKSpriteNode!
    var scrollLayer: SKNode!
    var obstacleSource: SKNode!
    var obstacleLayer: SKNode!
    var buttonRestart: MSButtonNode!
    var gameState: GameSceneState = .active
    var scoreLabel: SKLabelNode!
    
    
    var sinceTouch : CFTimeInterval = 0
    var spawnTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    let scrollSpeed: CGFloat = 100
    var points = 0

    func viewDidLoad(){
        if let view = self.view {
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
        }
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        playerShip = ((self.childNode(withName: "//PlayerShipSpriteScene")) as! SKSpriteNode)
        scrollLayer = self.childNode(withName: "scrollLayer")
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        obstacleSource = self.childNode(withName: "//obstacleNode")
        physicsWorld.contactDelegate = self
        buttonRestart = (self.childNode(withName: "buttonRestart") as! MSButtonNode)
        buttonRestart.selectedHandler = {
            let skView = self.view as SKView?
            let scene = GameScene(fileNamed: "GameScene") as GameScene?
            scene?.scaleMode = .aspectFill
            skView?.presentScene(scene)
        }
        buttonRestart.state = .MSButtonNodeStateHidden
        scoreLabel = (self.childNode(withName: "scoreLabel") as! SKLabelNode)
        scoreLabel.text = "\(points)"
        

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        if gameState != .active { return }
        playerShip.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
        playerShip.physicsBody?.applyAngularImpulse(1)
        sinceTouch = 0

        
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        if gameState != .active { return }
        let velocityY = playerShip.physicsBody?.velocity.dy ?? 0
        if velocityY > 400 {
            playerShip.physicsBody?.velocity.dy = 400
        }
        //Rotation
        if sinceTouch > 0.2 {
            let impulse = -2000 * fixedDelta
            playerShip.physicsBody?.applyAngularImpulse(CGFloat(impulse))
        }
        playerShip.zRotation.clamp(v1: CGFloat(-90).degreesToRadians(), CGFloat(30).degreesToRadians())
        playerShip.physicsBody?.angularVelocity.clamp(v1: -1, 3)
        sinceTouch += fixedDelta
        spawnTimer += fixedDelta
        
        scrollWord()
        updateObstacles()
    }
    
    func scrollWord() {
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        /* Loop through scroll layer nodes */
        for ground in scrollLayer.children as! [SKSpriteNode] {
          let groundPosition = scrollLayer.convert(ground.position, to: self)
          if groundPosition.x <= -ground.size.width / 2 {
              let newPosition = CGPoint(x: (self.size.width / 2) + ground.size.width, y: groundPosition.y)
              ground.position = self.convert(newPosition, to: scrollLayer)
          }
        }
    }
    
    func updateObstacles() {
        obstacleLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        for obstacle in obstacleLayer.children as! [SKReferenceNode] {
            let obstaclePosition = obstacleLayer.convert(obstacle.position, to:self)
            if obstaclePosition.x <= -26 {
                obstacle.removeFromParent()
            }
        }
        
        if spawnTimer >= 2.5 {
            let newObstacle = obstacleSource.copy() as! SKNode
            obstacleLayer.addChild(newObstacle)
            let randomPosition =  CGPoint(x: 640, y: CGFloat.random(in: -80...120))
            newObstacle.position = self.convert(randomPosition, to: obstacleLayer)
            spawnTimer = 0

        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {

        let contactA = contact.bodyA
        let contactB = contact.bodyB
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        if nodeA.name == "goal" || nodeB.name == "goal" {
          points += 1
          scoreLabel.text = String(points)
          return
        }
        
        if gameState != .active { return }
        gameState = .gameOver
        playerShip.physicsBody?.allowsRotation = false
        playerShip.physicsBody?.angularVelocity = 0
        playerShip.removeAllActions()
        
        let playerDeath = SKAction.run({
            self.playerShip.zRotation = CGFloat(-90).degreesToRadians()
        })

        playerShip.run(playerDeath)
        buttonRestart.state = .MSButtonNodeStateActive
    }
}
