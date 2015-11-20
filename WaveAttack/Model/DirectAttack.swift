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
    
    var speed :CGFloat = 20
    override func runAction(){
        //enemy.gameScene!.player!.
        
        var bullet = GameSKSpriteNode(imageNamed: "beams")
        bullet.gameObject = self
        bullet.size = CGSize (width: 10, height: 20)
        var phys = SKPhysicsBody(rectangleOfSize: bullet.size)
        bullet.physicsBody = phys
        phys.linearDamping = 0
        phys.categoryBitMask = CollisionLayer.EnemyAttacks.rawValue
        phys.collisionBitMask = 0
        phys.contactTestBitMask =  CollisionLayer.PlayerHpArea.rawValue
        phys.affectedByGravity = false
        phys.velocity = CGVector(dx: 0, dy: -speed)
        bullet.position = (enemy!.currentPos)
        enemy!.gameScene!.gameLayer!.addChild(bullet)
        
        
    }
    
    
}