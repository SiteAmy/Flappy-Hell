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

//vector calculations

func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}
func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}
#if !(arch(x86_64) || arch(arm64))
  func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
  }
#endif
extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  func normalized() -> CGPoint {
    return self / length()
  }
}



class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var playerShip: SKSpriteNode!
    var scrollLayer: SKNode!
    var obstacleSource: SKNode!
    var obstacleLayer: SKNode!
    var turretSource: SKNode!
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
        turretSource = self.childNode(withName: "//turretNode")
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
        
        for turret in obstacleLayer.children as! [SKReferenceNode] {
            let turretPosition = obstacleLayer.convert(turret.position, to:self)
            if turretPosition.x <= -26 {
                turret.removeFromParent()
            }
        }
        
        if spawnTimer >= 2.5 {
            let newObstacle = obstacleSource.copy() as! SKNode
            obstacleLayer.addChild(newObstacle)
            let randomPositionTower =  CGPoint(x: 640, y: CGFloat.random(in: 50...220))
            newObstacle.position = self.convert(randomPositionTower, to: obstacleLayer)
            let newTurret = turretSource.copy() as! SKNode
            obstacleLayer.addChild(newTurret)
            let randomPositionTurret =  CGPoint(x: 530, y: 67)
            newTurret.position = self.convert(randomPositionTurret, to: obstacleLayer )
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
    
    
    
    // test script bullet player
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let bulletPlayer = SKSpriteNode(imageNamed: "Bullet_Player_Sprite")
        bulletPlayer.position = playerShip.position
        let offset = touchLocation - bulletPlayer.position
        if offset.x < 0 { return }
        addChild(bulletPlayer)
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + bulletPlayer.position
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
          let actionMoveDone = SKAction.removeFromParent()
          bulletPlayer.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
}
