//
//  SolidMedium.swift
//  WaveAttack
//
//  Created by yat on 23/10/2015.
//
//

import Foundation
import SpriteKit


class SolidMedium:Medium{
    

    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
        //propagationSpeed = 3.5
        
        
        //self.sprite = GameSKShapeNode(rect: CGRect(origin: CGPoint(x: 0,y: 0), size: gameScene.gameArea!.size))
        var tempSprite: GameSKSpriteNode = getSprite() as! GameSKSpriteNode
        tempSprite.size = size
        var phys:SKPhysicsBody? = nil
       // var anPoint = tempSprite.anchorPoint
        if tempSprite.texture == nil{
            phys = SKPhysicsBody(rectangleOfSize: size)
        }else{
            phys = SKPhysicsBody(texture: tempSprite.texture!, size: size)
        }
        phys!.categoryBitMask = CollisionLayer.Objects.rawValue
        phys!.affectedByGravity = false
        phys!.collisionBitMask = CollisionLayer.Objects.rawValue
        //tempSprite.physicsBody = phys
        tempSprite.name = GameObjectName.Medium.rawValue
        //contact Sprite
        tempSprite.position = position

        phys = SKPhysicsBody (edgeLoopFromPath: self.path!)
        
   //     phys.usesPreciseCollisionDetection = true
        phys!.collisionBitMask = 0x0
        //phys.affectedByGravity = false
        phys!.categoryBitMask = CollisionLayer.Medium.rawValue
        self.physContactSprite.physicsBody = phys
        //getSprite()!.physicsBody = phys
        
       // self.getSprite()!.addChild(self.physContactSprite)
        //--------------------
        
        
        tempSprite.addChild(self.physContactSprite)
        
    }
    
}
