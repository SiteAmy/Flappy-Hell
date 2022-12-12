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
        //scene.size = CGSize(width: 380, height: 700)
        //scene.scaleMode = .fill
        return scene
        }
    
    var body: some View {
        SpriteView(scene:scene)
        //scene.scaleMode = .aspectFill
            //.frame(width: 380, height: 700)
            //.ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
