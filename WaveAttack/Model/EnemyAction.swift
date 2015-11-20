//
//  EnemyAction.swift
//  WaveAttack
//
//  Created by yat on 2/10/2015.
//
//

import Foundation

import SpriteKit
class EnemyAction{
    var timer : FrameTimer
    weak var enemy : DestructibleObject? = nil
    init(enemy : DestructibleObject, cd : CGFloat){
       timer = FrameTimer(duration:cd)
        self.enemy = enemy
        timer.repeatTimer({
            ()->() in
            if self.enemy == nil || self.enemy!.dead{
                self.timer.stopTimer()
                GameScene.current!.generalUpdateList.remove(Weak(self.timer))
                return
            }
            self.runAction()
        })
        GameScene.current!.generalUpdateList.insert(Weak(timer))
    }
    
    func runAction(){}
}