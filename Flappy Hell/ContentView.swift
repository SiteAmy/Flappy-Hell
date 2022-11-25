//
//  ContentView.swift
//  Flappy Hell
//
//  Created by Amy Nijmeijer on 22/11/2022.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    var scene: SKScene{
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 400)
        scene.scaleMode = .fill
        return scene
        }
    
    var body: some View {
        SpriteView(scene:scene)
            .frame(width: 300, height: 400)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
