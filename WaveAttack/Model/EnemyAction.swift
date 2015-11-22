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
    var timer : FrameTimer? = nil
    var cd : CGFloat =  10
    weak var enemy : DestructibleObject? = nil
    init(enemy : DestructibleObject, cd : CGFloat){
        self.cd = cd
       
        self.enemy = enemy
    }
    func startAction(){
        timer = FrameTimer(duration:cd)
        timer!.repeatTimer({
            ()->() in
            if self.enemy == nil || self.enemy!.dead{
                self.timer!.stopTimer()
                GameScene.current!.generalUpdateList.remove(Weak(self.timer!))
                return
            }
            self.runAction()
        })
        GameScene.current!.generalUpdateList.insert(Weak(timer!))

    }
    
    func runAction(){}
}