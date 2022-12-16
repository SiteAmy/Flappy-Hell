//
//  PlayerShip.swift
//  Flappy Hell
//
//  Created by Amy Nijmeijer on 12/12/2022.
//

import UIKit
import Foundation
import SpriteKit
import GameplayKit

class PlayerShip: SKSpriteNode{
    
    var sinceTouch : CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    var playerShipSprite: SKSpriteNode!



    func spawned(){
        playerShipSprite = ((self.childNode(withName: "//PlayerShipScene")) as! SKSpriteNode)
        playerShipSprite.isPaused = false
    }
    
    func tapped() {
        /* Called when a touch begins */
        playerShipSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
        playerShipSprite.physicsBody?.applyAngularImpulse(1)
        sinceTouch = 0

    }

    func updateShip(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        let velocityY = playerShipSprite.physicsBody?.velocity.dy ?? 0
        if velocityY > 400 {
            playerShipSprite.physicsBody?.velocity.dy = 400
        }
        //Rotation
        if sinceTouch > 0.2 {
            let impulse = -2000 * fixedDelta
            playerShipSprite.physicsBody?.applyAngularImpulse(CGFloat(impulse))
        }
        playerShipSprite.zRotation.clamp(v1: CGFloat(-90).degreesToRadians(), CGFloat(30).degreesToRadians())
        playerShipSprite.physicsBody?.angularVelocity.clamp(v1: -1, 3)
        sinceTouch += fixedDelta
    }
}





