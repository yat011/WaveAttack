//
//  File.swift
//  WaveAttack
//
//  Created by yat on 23/9/2015.
//
//

import Foundation
import SpriteKit

class HpBar : SKShapeNode {
    
    var max : CGFloat = 1
    var current : CGFloat = 0
    var hpBar : SKSpriteNode? = nil
    var maxWidth : CGFloat  = 10
    var label : SKLabelNode? = nil
    
    static func createHpBar(rect: CGRect, max : CGFloat , current : CGFloat, belongTo : GameObject) -> HpBar{
        var bar = HpBar(rectOfSize:  rect.size, cornerRadius: 2)
        bar.position = rect.origin
       // super.init(rectOfSize: size, cornerRadius: 2)
        print("hpbar rect : \(rect)")
        bar.strokeColor = SKColor.blackColor()
        bar.fillColor = SKColor.blackColor()
    
        bar.max = max
        bar.current = current
       // bar.hpBar = SKSpriteNode(imageNamed: "redbar")
        bar.hpBar =  SKSpriteNode(color: SKColor.redColor(), size: CGSize())
        
        var maxWidth = rect.width
        bar.maxWidth = maxWidth
    
        var tempCur = current
        if (tempCur < 0){
            tempCur = 0
            bar.current = 0
        }
        bar.hpBar!.size = CGSize(width: tempCur / max * maxWidth, height: rect.height)
        bar.hpBar!.anchorPoint = CGPoint(x: 0,y: 0.5)
        bar.hpBar!.position = CGPoint(x: -maxWidth/2, y: 0)
        //bar.hpBar!.position = rect.origin
        //print(bar.hpBar!.position)
        bar.addChild(bar.hpBar!)
        bar.zPosition = 101
        weak var wBar : HpBar? = bar
      
        belongTo.subscribeEvent(GameEvent.HpChanged.rawValue, call: { (sender : GameObject, nth) -> () in
            if wBar == nil {
                return
            }
            if (sender is DestructibleObject){
                let temp = sender as! DestructibleObject
                var val = temp.hp
                wBar!.updateCurrentHp(val)
                
            }else if sender is Player{
                let temp = sender as! Player
                wBar!.updateCurrentHp(temp.hp)
                var first = SKAction.moveByX(0, y: -5, duration: 0.3)
                var reverse = first.reversedAction()
                var actions = [first,reverse]
                
                wBar!.runAction(SKAction.repeatAction(SKAction.sequence(actions),count: 5))
        
            }
        })
        bar.alpha = 0.6
        bar.label = SKLabelNode(text: String(format: "%.2f / %.2f", bar.current, max))
        bar.label!.fontSize = 11
       bar.label!.position = CGPoint(x:  maxWidth/2, y: 0)
        bar.label!.fontColor = SKColor.whiteColor()
        bar.label!.horizontalAlignmentMode = .Right
        bar.label!.verticalAlignmentMode = .Center
        bar.label!.fontName = "Helvetica"
        bar.hpBar!.zPosition = 102
        bar.label!.zPosition = 105
        bar.label!.alpha = 1
        bar.label!.hidden = true
        bar.addChild(bar.label!)
        return bar
    }
    
    func updateCurrentHp(cur : CGFloat) {
        current = cur
        if (current < 0){
            current = 0
        }
        hpBar!.runAction( SKAction.resizeToWidth(current / max * maxWidth, duration: 1))
        
        label!.text = String(format: "%.2f / %.2f", current, max)
    }
    
    

    
    
}