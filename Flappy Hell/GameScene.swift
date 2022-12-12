//
//  GameScene.swift
//  Flappy Hell
//
//  Created by Amy Nijmeijer on 22/11/2022.
//

import Foundation
import SpriteKit
import GameplayKit

class GameScene: SKScene {
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
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
    }

    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
