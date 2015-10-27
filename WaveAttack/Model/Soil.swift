//
//  Soil.swift
//  WaveAttack
//
//  Created by yat on 13/9/2015.
//
//

import Foundation
import SpriteKit

class Soil : SolidMedium{
    
    var sprite : GameSKSpriteNode = GameSKSpriteNode(color: SKColor.brownColor(), size: CGSize())
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
        //sprite.anchorPoint = CGPoint()
        super.initialize(size, position: position, gameScene: gameScene)
        propagationSpeed = 2
        
    }
    
    override func getSprite() -> SKNode? {
        return sprite
    }
    
}