//
//  StoringPowerBallUI.swift
//  WaveAttack
//
//  Created by yat on 22/11/2015.
//
//

import Foundation
import SpriteKit


class ChargingPowerBallUI : SKSpriteNode{
   
    var completeTime :CGFloat = 1
    var timer = FrameTimer(duration: 1)
    static let maxAlpha = 0.5.f
    static let blendingFactor = 0.4.f
    var complete: Bool = false
    convenience init(completeTime  :CGFloat, color: SKColor){
        self.init(imageNamed:"attack")
        self.color = color
        self.colorBlendFactor = ChargingPowerBallUI.blendingFactor
        self.completeTime = completeTime
        self.alpha = 0
    }
    
    func startCharging(){
       timer.reset()
        timer.setTargetTime(completeTime)
        timer.addToGeneralUpdateList()
        timer.updateFunc = {
           Void in
            self.alpha = ChargingPowerBallUI.maxAlpha * self.timer.progress
            
        }
        timer.startTimer({
            Void in
            self.completeCharging()
            self.timer.stopTimer()
            self.timer.removeFromGeneralUpdateList()
        })
    }
    func discharge(completion: (()->())){
        self.runAction(SKAction.fadeAlphaTo(0, duration: 0.2),completion:completion)
    }
    func completeCharging(){
        self.complete = true
        self.colorBlendFactor = 0.6
        self.alpha = 0.8
        let spark = SKEmitterNode(fileNamed: "Spark.sks")
        spark!.particleSize = CGSize(width: 30, height: 30)
        spark!.particleColorSequence = nil
        spark!.particleColor = self.color
        spark!.position = CGPoint(x: 0, y: self.size.height/2-20)
        
        self.addChild(spark!)
        AnimateHelper.animateFlashEffect(self, duration: 100, completion: nil)
    }
    func shoot(){
        var actions = [SKAction.moveByX(0, y: 200, duration: 0.3), SKAction.fadeAlphaTo(0, duration: 0.3)]
        self.runAction(SKAction.group(actions),completion:{
            Void in
            self.removeFromParent()
        })
    }
    
    
    
    
}