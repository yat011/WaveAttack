//
//  AnimateHelper.swift
//  WaveAttack
//
//  Created by yat on 20/11/2015.
//
//

import Foundation
import SpriteKit
class AnimateHelper{
    
    static func animateFlashEffect (node :SKNode, duration : CGFloat, completion: (()->())?){
        var actions = [SKAction.fadeAlphaTo(0.6, duration: 0.25), SKAction.fadeAlphaTo(1, duration: 0.25)]
        var count = Int(duration/0.5 + 0.5)
        if completion != nil{
            node.runAction(SKAction.repeatAction(SKAction.sequence(actions), count: count),completion : completion!)
        }else{
            node.runAction(SKAction.repeatAction(SKAction.sequence(actions), count: count))
        }
    
    }
    static var tempSet = Set<GameObject>()
    static func moveToTargetY(node:SKNode, speed: CGFloat, targetY: CGFloat, completion:(()->())?){
        
        var timer = FrameTimer(duration: 1e6)
        tempSet.insert(timer)
        timer.addToGeneralUpdateList()
        timer.startTimer(nil)
        timer.updateFunc={
            Void in
            if node.position.y + speed >= targetY {
                node.position.y = targetY
                tempSet.remove(timer)
                timer.stopTimer()
                completion?()
            }else{
                node.position.y += speed
            }
        }
        
        
    }
    static func moveToTargetX(node:SKNode, targetX: CGFloat,time:CGFloat, completion:(()->())?){
        
        var timer = FrameTimer(duration: time)
        var speed = (targetX - node.position.x)/FrameTimer.getFramesfromDuration(time).f
        tempSet.insert(timer)
        timer.addToGeneralUpdateList()
        timer.startTimer(nil)
        timer.updateFunc={
            Void in
            if speed > 0{
                if node.position.x + speed >= targetX {
                    node.position.x = targetX
                    tempSet.remove(timer)
                    timer.removeFromGeneralUpdateList()
                    timer.stopTimer()
                    completion?()
                    return
                }else{
                    node.position.x += speed
                }
            }else{
                if node.position.x + speed <= targetX {
                    node.position.x = targetX
                    tempSet.remove(timer)
                    timer.removeFromGeneralUpdateList()
                    timer.stopTimer()
                    completion?()
                    return
                }else{
                    node.position.x += speed
                }
            }
        }
        
        
    }
    static func resizeTo(node:SKSpriteNode, targetSize: CGSize, time:CGFloat, completion:(()->())?){
        
        var timer = FrameTimer(duration: 1e6)
        var oriSize = node.size
        var speedW = (targetSize.width - oriSize.width)/FrameTimer.getFramesfromDuration(time).f
        var speedH = (targetSize.height - oriSize.height)/FrameTimer.getFramesfromDuration(time).f
        tempSet.insert(timer)
        timer.addToGeneralUpdateList()
        timer.startTimer(nil)
        timer.updateFunc={
            Void in
            if speedW > 0 {
                if  node.size.width + speedW >= targetSize.width {
                    node.size = targetSize
                    tempSet.remove(timer)
                    timer.stopTimer()
                    timer.removeFromGeneralUpdateList()
                    completion?()
                    return
                }else{
                    node.size.width += speedW
                }
                
            }else {
                if  node.size.width + speedW <= targetSize.width {
                    node.size = targetSize
                    tempSet.remove(timer)
                    timer.stopTimer()
                    timer.removeFromGeneralUpdateList()
                    completion?()
                    return
                }else{
                    node.size.width += speedW
                }
            }
            node.size.height += speedH
        }
        
        
    }
    static func scaleTo(node:SKSpriteNode, targetSize: CGSize, time:CGFloat, completion:(()->())?){
        
        var timer = FrameTimer(duration: 1e6)
        var oriSize = node.size
        var targetScaleX = (targetSize.width/oriSize.width)
        var targetScaleY = (targetSize.height/oriSize.height)
        var speedW = (targetScaleX - 1)/FrameTimer.getFramesfromDuration(time).f
        var speedH = (targetScaleY - 1)/FrameTimer.getFramesfromDuration(time).f
        tempSet.insert(timer)
        timer.addToGeneralUpdateList()
        timer.startTimer(nil)
        timer.updateFunc={
            Void in
            if speedW > 0 {
                if  node.xScale + speedW >= targetScaleX {
                  //  node.runAction(SKAction.scaleTo(targetScaleX, duration: 0))
                    node.runAction(SKAction.scaleXTo(targetScaleX, y: targetScaleY, duration: 0))
                    //node.xScale = targetScaleX
                    //node.yScale = targetScaleY
                    tempSet.remove(timer)
                    timer.stopTimer()
                    timer.removeFromGeneralUpdateList()
                    completion?()
                    return
                }else{
 //                   node.xScale += speedW
                    node.runAction(SKAction.scaleXTo(targetScaleX, y: targetScaleY, duration: 0))
//                     node.runAction(SKAction.scaleXBy(speedW, y: speedH, duration: 0))
                }
                
            }else {
                if  node.xScale + speedW <= targetScaleX {
                    node.runAction(SKAction.scaleXTo(targetScaleX, y: targetScaleY, duration: 0))
           //         node.xScale = targetScaleX
            //        node.yScale = targetScaleY
                    tempSet.remove(timer)
                    timer.stopTimer()
                    timer.removeFromGeneralUpdateList()
                    completion?()
                    return
                }else{
//                    node.xScale += speedW
                    
                    node.runAction(SKAction.scaleXTo(targetScaleX, y: targetScaleY, duration: 0))
//                     node.runAction(SKAction.scaleXBy(speedW, y: speedH, duration: 0))
                }
            }
          //  node.yScale += speedH
          //  print(node.size)
        }
        
        
    }
    static func scaleBack(node:SKSpriteNode,  time:CGFloat, completion:(()->())?){
        var timer = FrameTimer(duration: 1e6)
        //var oriSize = node.size
        var targetScaleX = 1.f
        var targetScaleY = 1.f
        var speedW = (1 - node.xScale)/FrameTimer.getFramesfromDuration(time).f
        var speedH = (1 - node.yScale)/FrameTimer.getFramesfromDuration(time).f
        tempSet.insert(timer)
        timer.addToGeneralUpdateList()
        timer.startTimer(nil)
        timer.updateFunc={
            Void in
            if speedW > 0 {
                if  node.xScale + speedW >= targetScaleX {
                    //  node.runAction(SKAction.scaleTo(targetScaleX, duration: 0))
                    node.runAction(SKAction.scaleXTo(targetScaleX, y: targetScaleY, duration: 0))
                    //node.xScale = targetScaleX
                    //node.yScale = targetScaleY
                    tempSet.remove(timer)
                    timer.stopTimer()
                    timer.removeFromGeneralUpdateList()
                    completion?()
                    return
                }else{
                    //                   node.xScale += speedW
                    node.runAction(SKAction.scaleXTo(targetScaleX, y: targetScaleY, duration: 0))
                    //                     node.runAction(SKAction.scaleXBy(speedW, y: speedH, duration: 0))
                }
                
            }else {
                if  node.xScale + speedW <= targetScaleX {
                    node.runAction(SKAction.scaleXTo(targetScaleX, y: targetScaleY, duration: 0))
                    //         node.xScale = targetScaleX
                    //        node.yScale = targetScaleY
                    tempSet.remove(timer)
                    timer.stopTimer()
                    timer.removeFromGeneralUpdateList()
                    completion?()
                    return
                }else{
                    //                    node.xScale += speedW
                    
                    node.runAction(SKAction.scaleXTo(targetScaleX, y: targetScaleY, duration: 0))
                    //                     node.runAction(SKAction.scaleXBy(speedW, y: speedH, duration: 0))
                }
            }
        }
        
        
    }
}