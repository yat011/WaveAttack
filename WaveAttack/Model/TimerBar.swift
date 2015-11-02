//
//  TimerBar.swift
//  WaveAttack
//
//  Created by yat on 23/10/2015.
//
//

import Foundation
import SpriteKit
class TimerUI : SKShapeNode{
    
    
    
    var max : CGFloat = 1
    var current : CGFloat = 0
    var timeBar : SKSpriteNode? = nil
    var maxheight : CGFloat  = 10
    var label : SKLabelNode? = nil
    var timerIcon : SKSpriteNode? = nil
    static func createInstance( ) -> TimerUI{
        var rect = CGRect(origin: CGPoint(x: 170,y: 150), size: CGSize(width: 30, height: 300))
        
        var bar = TimerUI(rectOfSize: rect.size, cornerRadius: 1)
        bar.zPosition = 1000000
        bar.position = rect.origin
        // super.init(rectOfSize: size, cornerRadius: 2)
       // print("hpbar rect : \(rect)")
        bar.strokeColor = SKColor.blueColor()
       // bar.fillColor = SKColor.blueColor()
       // bar.max = timelimit
        //bar.current = timelimit
        // bar.hpBar = SKSpriteNode(imageNamed: "redbar")
        bar.timeBar =  SKSpriteNode(color: SKColor.yellowColor(), size: CGSize())
        bar.maxheight = rect.size.height
       
        
        
        
        bar.timeBar!.size = CGSize(width: rect.size.width, height: rect.height)
        bar.timeBar!.position = CGPoint (x: 0, y: -rect.height / 2)
        bar.timeBar!.anchorPoint = CGPoint(x: 0.5,y: 0)
      //  bar.hpBar!.anchorPoint = CGPoint(x: 0,y: 0)
      //  bar.hpBar!.position = rect.origin
        //print(bar.hpBar!.position)
        bar.addChild(bar.timeBar!)
        //bar.zPosition = 101
        
        bar.alpha = 0.6
        
        
        bar.timerIcon = SKSpriteNode(imageNamed: "clock")
        bar.timerIcon!.size =  CGSize(width: 30,height: 30)
          //  SKSpriteNode(color: SKColor.greenColor(), size: CGSize(width: 30,height: 30))
        bar.timerIcon!.position = CGPoint(x: 0, y: 167)
        bar.addChild(bar.timerIcon!)
        
        /*
        bar.label = SKLabelNode(text: String(format: "%.2f / %.2f", bar.current, max))
        bar.label!.fontSize = 11
        bar.label!.position = CGPoint(x: rect.origin.x + maxWidth, y: rect.origin.y)
        bar.label!.fontColor = SKColor.whiteColor()
        print ("label \(bar.label!.position)")
        bar.label!.horizontalAlignmentMode = .Right
        bar.label!.verticalAlignmentMode = .Bottom
        bar.label!.fontName = "Helvetica"
        bar.hpBar!.zPosition = 102
        bar.label!.zPosition = 105
        bar.label!.alpha = 1
        bar.addChild(bar.label!)
*/
        return bar
    }
    
    func startTimer(timelimit :Double) {
        
        timeBar!.runAction( SKAction.resizeToHeight(0, duration: timelimit))
        timerIcon!.runAction(SKAction.rotateByAngle(-MathHelper.PI * 2, duration: timelimit))
        
      //  label!.text = String(format: "%.2f / %.2f", current, max)
    }
    func resetTimer(){
        timeBar!.runAction(SKAction.resizeToHeight(maxheight, duration: 0))
    }
    
    
    
    
}