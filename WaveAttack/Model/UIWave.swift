//
//  UIWave.swift
//  WaveAttack
//
//  Created by James on 21/9/15.
//
//

import Foundation
import SpriteKit

class UIWave : GameObject {
    
    var sprite : GameSKSpriteNode? = GameSKSpriteNode(imageNamed: "box")
    
    init(size : CGSize , position : CGPoint){
        
        super.init()
        if sprite == nil {
            print("sprite == nil")
            exit(1)
        }
        
        
        self.sprite!.size = size
        self.sprite!.position = position
        self.sprite!.gameObject = self
    }
    override func getSprite() -> SKNode? {
        return sprite
    }
}