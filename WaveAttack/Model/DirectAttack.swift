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
    
    var enemy : DestructibleObject? = nil
    var damage: CGFloat = 100
    init(){
        
    }
    
    func initialize(enemy : DestructibleObject){
        self.enemy = enemy
    }
    
    func runAction(finish : (() ->())){
        //enemy.gameScene!.player!.
        
        print("action run")
        var bullet = SKSpriteNode(imageNamed: "beams")
        bullet.position = (enemy?.getSprite()!.position)!
        bullet.size = CGSize (width: 50, height: 50)
        print(bullet.position)
        enemy!.gameScene!.gameLayer!.addChild(bullet)
        bullet.runAction(SKAction.moveToY( -50 , duration: 1.5), completion: { () -> () in
            bullet.removeFromParent()
            self.enemy!.gameScene!.player!.changeHpBy(-self.damage)
            finish()
        })
     
    }
    
    
}