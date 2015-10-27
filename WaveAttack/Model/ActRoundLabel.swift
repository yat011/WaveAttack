//
//  ActRoundLabel.swift
//  WaveAttack
//
//  Created by yat on 6/10/2015.
//
//

import Foundation
import SpriteKit

class ActRoundLabel : SKShapeNode {
    
    
    static func createActRoundLabel(rect : CGRect , enemy :EnemyActable ) -> ActRoundLabel{
        var res = ActRoundLabel(rect: rect, cornerRadius: 0.5)
        var label =  SKLabelNode(text: String(enemy.leftRound))
        //var back = SKSpriteNode(color: SKColor.purpleColor(), size: rect.size)
       // back.anchorPoint  = CGPoint(x: 0.5, y: 0)
        //label.zPosition  = 2
        res.strokeColor = SKColor.blackColor()
        res.fillColor = SKColor.blackColor()
        res.zPosition = 10
        //back.zPosition = 1
      //  back.strokeColor = SKColor.blueColor()
        //back.fillColor = SKColor.redColor()
       // var label = SKLabelNode(text: String(enemy.leftRound))
        label.fontSize = 14
        label.zPosition = 15
        label.fontColor = SKColor.whiteColor()
        label.fontName = "Helvetica"
        //label.addChild(text)
        label.horizontalAlignmentMode = .Left
        label.position = CGPoint(x: rect.origin.x , y: rect.origin.y)
        weak var wLabel: SKLabelNode? = label
        if (enemy is GameObject){
            let obj = enemy as! GameObject
            obj.subscribeEvent(GameEvent.RoundChanged.rawValue, call: { (sender : GameObject) -> () in
                if wLabel == nil {
                    return
                }
                wLabel!.text = String(enemy.leftRound)
            })
            
            
        }
        res.addChild(label)
        return res
    }
    
    
    
    
}