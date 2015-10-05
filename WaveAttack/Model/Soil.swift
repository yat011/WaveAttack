//
//  Soil.swift
//  WaveAttack
//
//  Created by yat on 13/9/2015.
//
//

import Foundation
import SpriteKit

class Soil : Medium {
    
    var sprite : GameSKShapeNode? = nil
    override var path: CGPath? { get{ return sprite!.path}}
    
  
    
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
        propagationSpeed = 3.5
        
        
        self.sprite = GameSKShapeNode(rect: CGRect(origin: CGPoint(x: 0,y: 0), size: gameScene.gameArea!.size))
        
        let phys = SKPhysicsBody(rectangleOfSize: size, center: CGPoint(x: size.width / 2, y: size.height / 2))
        phys.categoryBitMask = CollisionLayer.Medium.rawValue
        phys.affectedByGravity = false
        phys.collisionBitMask = 0x0
        // sprite!.physicsBody = phys
        sprite!.name = GameObjectName.Medium.rawValue
        sprite?.fillColor = SKColor.brownColor()
    }
    
    
    
    
    override func getSprite() -> SKNode? {
        return sprite
    }
    
}