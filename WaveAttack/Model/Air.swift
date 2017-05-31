//
//  Soil.swift
//  WaveAttack
//
//  Created by yat on 13/9/2015.
//
//

import Foundation
import SpriteKit

class Air: Medium {
    
    var sprite : GameSKSpriteNode? = GameSKSpriteNode(imageNamed: "DaytimeSky")
    
    
    
    
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
     //   propagationSpeed = 3.5
        
        
        self.sprite?.size = size
        self.sprite?.position = position
        self.sprite?.zPosition = -1
       // self.sprite?.anchorPoint  = CGPoint()
        
        sprite!.name = "air"
        //sprite?.fillColor = SKColor.blueColor()
        
        //self.sprite!.runAction(SKAction.scaleXTo(2, duration: 0))
        
      //  sprite!.addChild(self.physContactSprite)
    }
    
    
    
    
    
    override func getSprite() -> SKNode? {
        return sprite
    }
    
}