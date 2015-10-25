//
//  CharScene.swift
//  WaveAttack
//
//  Created by James on 23/10/15.
//
//

import Foundation
import SpriteKit

class CharScene:TransitableScene{
    var character:Character?
    override init(size: CGSize, viewController: GameViewController, prevScene: [GameViewController.Scene]) {
        
        
        super.init(size: size, viewController: viewController, prevScene: prevScene)
        selfScene=GameViewController.Scene.CharScene
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}