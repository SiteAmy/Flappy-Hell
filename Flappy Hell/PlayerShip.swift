//
//  PlayerShip.swift
//  Flappy Hell
//
//  Created by Amy Nijmeijer on 12/12/2022.
//
/*
import UIKit
import Foundation
import SpriteKit
import GameplayKit

class PlayerShip: SKSpriteNode{
    
    var playerShip : SKSpriteNode!

    func didMove(to view: SKView) {
        /* Setup your scene here */
        playerShip = (self.childNode(withName: "//PlayerShipScene") as! SKSpriteNode)
        
        playerShip.isPaused = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        playerShip.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
    }

    func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        let velocityY = playerShip.physicsBody?.velocity.dy ?? 0
        if velocityY > 400 {
            playerShip.physicsBody?.velocity.dy = 400
        }
    }
}
*/




