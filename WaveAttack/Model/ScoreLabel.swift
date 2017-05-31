//
//  ScoreLabel.swift
//  WaveAttack
//
//  Created by yat on 17/11/2015.
//
//

import Foundation
import SpriteKit

class ScoreLabel : SKLabelNode{
    
    
    convenience init(position : CGPoint){
        self.init(fontNamed:  "Helvetica")
        self.fontSize = 18
        self.text = String(format: "%.1f", 0)
        self.fontColor = SKColor.yellowColor()
        self.horizontalAlignmentMode = .Right
        self.zPosition = 10000000
    
        self.position = position
     //   let actions = [ SKAction.moveByX(0, y: 50, duration: 1.5), SKAction.fadeOutWithDuration(1.5)]
    //    self.runAction(SKAction.sequence([SKAction.group(actions),SKAction.removeFromParent()]))
    }
    
    func setScore(score : CGFloat){
       self.text = String(format: "%.1f", score)
    }
}