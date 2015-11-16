//
//  SpawnPoint.swift
//  WaveAttack
//
//  Created by yat on 16/11/2015.
//
//

import Foundation
import SpriteKit

class SpawnPoint :GameObject{
    
    var x : CGFloat = 0
    var type :String = ""
    var yLayer  = GameLayer.ZFRONT
    var spawnPt : CGPoint{
        get{
            var y : CGFloat = 0
            if yLayer == GameLayer.ZFRONT{
                y = (GameScene.current!.gameLayer?.ground?.frontY)!
            }else{
                y = (GameScene.current!.gameLayer?.ground!.backY)!
            }
            return CGPoint(x: x, y: y)
            
        }
    }
    
    var afterTime:CGFloat = 0
    var interval:CGFloat = 10
    var currentNum = 0
    var maxNum = 10
    var afterFirstAttack = false
    
    var timer : FrameTimer? = nil
    
    
    func afterAddToScene(){
        if afterFirstAttack == false{
            timer = FrameTimer(duration: afterTime)
            GameScene.current!.generalUpdateList.insert(timer!)
            var f : (()->())? = nil
            f = {
                ()->() in
                self.spawnObjectAndAdd()
                self.timer!.reset()
                self.timer!.setTargetTime(self.interval)
                self.timer!.startTimer(f)
            }
            timer?.startTimer(f!)
            
        }
    }
    
    func spawnObjectAndAdd() {
       var obj = GameObjectFactory.getInstance().create(type)
        if obj is Spawnable{
            let sp = obj as! Spawnable
            sp.spawnInit(spawnPt)
        }else{
            fatalError("not spawnable")
        }
        currentNum++
        obj?.subscribeEvent(GameEvent.Dead.rawValue, call: {
            (obj:GameObject)->() in
           currentNum--
        })
        GameScene.current!.gameLayer!.addGameObject(obj!)
        (obj as! DestructibleObject).afterAddToScene()
    }
    
    
}