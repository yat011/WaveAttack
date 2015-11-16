//
//  SmallObject.swift
//  WaveAttack
//
//  Created by yat on 16/11/2015.
//
//

import Foundation
import SpriteKit
class SmallObject: DestructibleObject{
   
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
        super.initialize(size, position: position, gameScene: gameScene)
        for each in sprites{
           isFront[each] = true
        }
    }
   
    
    override func changeToFront(phys :SKPhysicsBody){
        isFront[phys.node!] = true
        phys.categoryBitMask = CollisionLayer.SmallObjects.rawValue
        phys.collisionBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue
        phys.contactTestBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue
    }
    override func createPhysicsBody(size: CGSize) -> SKPhysicsBody {
       var phys = super.createPhysicsBody(size)
        phys.categoryBitMask = CollisionLayer.SmallObjects.rawValue
        phys.collisionBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue
        phys.contactTestBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue
        return phys
    }
}