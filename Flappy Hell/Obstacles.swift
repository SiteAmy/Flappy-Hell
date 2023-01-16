//
//  Obstacles.swift
//  Flappy Hell
//
//  Created by Amy Nijmeijer on 12/01/2023.
//

import Foundation
import SpriteKit
import GameplayKit


class Obstacles: SKNode {
    
    var obstacleSource: SKNode!
    var obstacleLayer: SKNode!
    var spawnTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    let scrollSpeed: CGFloat = 100
    
    func initObstacles() {
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        obstacleSource = self.childNode(withName: "Obstacle")
    }
    
    func updateObstacles() {
        
        obstacleLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        for obstacle in obstacleLayer.children as! [SKReferenceNode] {
            let obstaclePosition = obstacleLayer.convert(obstacle.position, to:self)
            if obstaclePosition.x <= -26 {
                obstacle.removeFromParent()
            }
        }
        
        if spawnTimer >= 1 {
            let newObstacle = obstacleSource.copy() as! SKNode
            let randomPosition =  CGPoint(x: 347, y: CGFloat.random(in: 100...370))
            newObstacle.position = self.convert(randomPosition, to: obstacleLayer)
            spawnTimer = 0

        }
        
    }
       
    
}
