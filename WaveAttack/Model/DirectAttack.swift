//
//  DirectAttack.swift
//  WaveAttack
//
//  Created by yat on 2/10/2015.
//
//

import Foundation
import SpriteKit
class DirectAttack : EnemyAction{
    
    var damage: CGFloat = 100
    
    var speed :CGFloat = 100
    override func runAction(){
        //enemy.gameScene!.player!.
        var bullet = createBullet()
        var targetPt = GameScene.current!.convertPoint(CGPoint(x: GameScene.current!.size.width/2 , y: 0 ),toNode : GameScene.current!.gameLayer!)
        targetPt.y = 0
        bullet.position = (enemy!.currentPos)
        moveTowards(enemy!.currentPos, target: targetPt, spriteNode: bullet)
        enemy!.gameScene!.gameLayer!.addChild(bullet)
        
        
    }
    func createBullet() -> GameSKSpriteNode{
        var bullet = GameSKSpriteNode(imageNamed: "beams")
        bullet.gameObject = self
        bullet.size = CGSize (width: 10, height: 20)
        var phys = SKPhysicsBody(rectangleOfSize: bullet.size)
        bullet.physicsBody = phys
        phys.linearDamping = 0
        phys.categoryBitMask = CollisionLayer.EnemyAttacks.rawValue
        phys.collisionBitMask = 0
        phys.fieldBitMask = 0
        phys.contactTestBitMask =  CollisionLayer.PlayerHpArea.rawValue
        phys.affectedByGravity = false
        bullet.zPosition = GameLayer.ZFRONT + 1
        return bullet
    }
    
    
    func moveTowards (oriPt : CGPoint , target :CGPoint, spriteNode : SKSpriteNode ){
        var dir: CGVector = target - oriPt
        dir.normalize()
        var speedV:CGVector = speed * dir
        var angle = acos(Float(dir.dot(CGVector(dx:0,dy:-1))))
        if (target.x - oriPt.x < 0 ){
            angle = -angle
        }
        spriteNode.physicsBody!.velocity = speedV
        spriteNode.runAction(SKAction.rotateByAngle(CGFloat(angle), duration: 0))
        
    }
    
    
}