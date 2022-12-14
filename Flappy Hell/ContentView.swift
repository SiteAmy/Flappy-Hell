//
//  ContentView.swift
//  Flappy Hell
//
//  Created by Amy Nijmeijer on 22/11/2022.
//

import SwiftUI
import SpriteKit
import GameplayKit

struct ContentView: View {
    
    var scene: SKScene{
        let scene = GameScene(fileNamed: "GameScene")!
        return scene
        }
    
    var body: some View {
        SpriteView(scene:scene)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
