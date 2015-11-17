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
    var y : CGFloat? = nil
    var type :String = ""
    var yLayer  = GameLayer.ZFRONT
    var spawnPt : CGPoint{
        get{
            if self.y != nil{
                return CGPoint(x: x,y: self.y!)
            }
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
    var timer : FrameTimer? = nil
    var workingStage : Int = 1
    var limited = false
    var limitCount = 10
    
    
    func afterAddToScene(){
            timer = FrameTimer(duration: afterTime)
            GameScene.current!.generalUpdateList.insert(timer!)
            var f : (()->())? = nil
            f = {
                ()->() in
                if self.workingStage != self.gameLayer.stage {
                    return
                }
                if self.limited {
                    if self.limitCount == 0{
                        return
                    }
                    self.limitCount--
                }
                self.spawnObjectAndAdd()
                self.timer!.reset()
                self.timer!.setTargetTime(self.interval)
                self.timer!.startTimer(f)
            }
            timer?.startTimer(f!)
            
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