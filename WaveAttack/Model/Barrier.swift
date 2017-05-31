//
//  Barrier.swift
//  WaveAttack
//
//  Created by yat on 24/11/2015.
//
//

import Foundation
import SpriteKit

class Barrier : GameObject, ContactListener{
    var originHp = 2000.f
    var hp = 2000.f
    var sprite : GameSKSpriteNode? = nil
    var duration = 20.f
    var timer = FrameTimer(duration: 1)
    var skill : BarrierSkill? = nil
   let radius = 100.f
    convenience init(maxHp : CGFloat,skill:BarrierSkill){
        self.init()
        originHp = maxHp
        hp = originHp
        sprite = createBarrier()
        var pt = gameLayer.convertPoint(CGPoint(x: gameScene!.size.width/2, y: 0), fromNode: gameScene!)
        pt.y = 0
        sprite?.position =  pt
        sprite!.zPosition = GameLayer.ZFRONT + 3
        gameLayer.addChild(sprite!)
        timer.setTargetTime(duration)
        timer.addToGeneralUpdateList()
        self.skill?.barriers.insert(self)
        timer.startTimer({
           Void in
            self.sprite?.removeFromParent()
            self.timer.removeFromGeneralUpdateList()
            self.skill?.barriers.remove(self)
        })
        
    
    }
        
    func createBarrier () -> GameSKSpriteNode{
        let spriteNode = GameSKSpriteNode(imageNamed: "barrier")
        spriteNode.size = CGSize(width: 2*radius, height: 2*radius)
        let phys = SKPhysicsBody(circleOfRadius: radius)
        phys.dynamic = false
        phys.categoryBitMask = CollisionLayer.Custom.rawValue
        phys.collisionBitMask = 0
        phys.contactTestBitMask = CollisionLayer.EnemyAttacks.rawValue
        spriteNode.physicsBody = phys
        spriteNode.contactListener = self
        return spriteNode
        
        
    }
    func contactWith(this: SKPhysicsBody , other: SKPhysicsBody){
        if other.node == nil{
            return
        }
      
        let gameobj =  other.node as! GameSKSpriteNode
        let atk = gameobj.gameObject as! DirectAttack
        hp -= atk.damage
         if (hp < 0){
            sprite!.removeFromParent()
            sprite = nil
         }else{
            AnimateHelper.animateFlashEffect(sprite!, duration: 0.5, completion: nil)
          }
         other.node?.removeFromParent()
        
        
    }
}