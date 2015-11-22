//
//  TripleBulletAttack.swift
//  WaveAttack
//
//  Created by yat on 21/11/2015.
//
//

import Foundation
import SpriteKit

class TripleBulletAttack: DirectAttack{
    
    var tripleTimer = FrameTimer(duration: 0.3)
    override func runAction(){
        var shootCount = 1
        //enemy.gameScene!.player!.
        var bullet = createBullet()
        var targetPt = GameScene.current!.convertPoint(CGPoint(x: GameScene.current!.size.width/2 , y: 0 ),toNode : GameScene.current!.gameLayer!)
        targetPt.y = 0
        bullet.position = (enemy!.currentPos)
        moveTowards(enemy!.currentPos, target: targetPt, spriteNode: bullet)
        enemy!.gameScene!.gameLayer!.addChild(bullet)

        tripleTimer.reset()
        tripleTimer.repeatTimer({
            Void in
            if self.enemy!.dead{
                self.tripleTimer.stopTimer()
                return
            }
           bullet = self.createBullet()
           targetPt = GameScene.current!.convertPoint(CGPoint(x: GameScene.current!.size.width/2 , y: 0 ),toNode : GameScene.current!.gameLayer!)
            targetPt.y = 0
            bullet.position = (self.enemy!.currentPos)
            self.moveTowards(self.enemy!.currentPos, target: targetPt, spriteNode: bullet)
            self.enemy!.gameScene!.gameLayer!.addChild(bullet)
            shootCount++
            if shootCount == 3{
                self.tripleTimer.stopTimer()
                return
            }

        })
        GameScene.current!.generalUpdateList.insert(Weak(tripleTimer))
        
        
    }
    
}