//
//  TimerBar.swift
//  WaveAttack
//
//  Created by yat on 23/10/2015.
//
//

import Foundation
import SpriteKit
class TimerUI : SKSpriteNode , Clickable{
    
    
    
    var max : CGFloat = 1
    var current : CGFloat = 0
    var timeBar : SKSpriteNode? = nil
    var maxheight : CGFloat  = 10
    var label : SKLabelNode? = nil
    var timerIcon : SKSpriteNode? = nil
    var bonusLabel = SKLabelNode(fontNamed: "Helvetica")
    
    static func createInstance( ) -> TimerUI{
        var rect = CGRect(origin: CGPoint(x: 170,y: 150), size: CGSize(width: 30, height: 300))
        
        var bar = TimerUI()
       bar.size = rect.size
        bar.zPosition = 1000000
        bar.position = rect.origin
        // super.init(rectOfSize: size, cornerRadius: 2)
       // print("hpbar rect : \(rect)")
       // bar.strokeColor = SKColor.blueColor()
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
        
        bar.bonusLabel.zPosition = 1100000000
        bar.bonusLabel.text = "Pow. X1"
        bar.bonusLabel.horizontalAlignmentMode = .Right
        bar.bonusLabel.position = CGPoint(x: 10, y: 190)
        bar.bonusLabel.fontSize = 20
        bar.bonusLabel.fontColor = SKColor.blackColor()
        bar.bonusLabel.hidden = true
        var fade = SKAction.fadeAlphaTo(0.7, duration: 0.5)
        var actions = [fade, SKAction.fadeAlphaTo(1, duration: 0.5)]
        bar.bonusLabel.runAction(SKAction.repeatActionForever(SKAction.sequence(actions)))
      //  bar.bonusLabel.hidden = true
        bar.addChild(bar.bonusLabel)
        
        
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
    var aniTimer :FrameTimer? = nil
    
    
    func startTimer(timelimit :CGFloat) {
        
        aniTimer = FrameTimer(duration: timelimit)
        aniTimer?.startTimer(nil)
        updateBonusLabel(1)
        
        //bonusLabel.hidden = false
        aniTimer?.updateFunc = {
            () -> () in
            self.timeBar!.runAction( SKAction.resizeToHeight( (1 - (self.aniTimer?.progress)!) * CGFloat(self.maxheight), duration:0))
            self.timerIcon!.runAction(SKAction.rotateToAngle(-MathHelper.PI * 2 * (self.aniTimer?.progress)!,duration: 0))
            for ch in  GameScene.current!.character{
                ch!.changeWaveSpeed(self.aniTimer!.progress)
            }
            
        }
     //   timeBar!.runAction( SKAction.resizeToHeight(0, duration: timelimit))
      //  timerIcon!.runAction(SKAction.rotateByAngle(-MathHelper.PI * 2, duration: timelimit))
        
      //  label!.text = String(format: "%.2f / %.2f", current, max)
    }
    func updateTimer(){
        aniTimer?.update()
        
    }
    
    func updateBonusLabel(bonus : CGFloat){
        bonusLabel.text = String(format: "Pow. X%.1f",bonus)
    }
    
    
    func resetTimer(){
        timeBar!.runAction(SKAction.resizeToHeight(maxheight, duration: 0))
        bonusLabel.hidden = true
    }
    
  
    func getRect () -> CGRect{
        var globalPos = GameScene.current!.convertPoint(self.frame.origin, fromNode: self.parent!)
        // print (globalPos)
        return CGRect (origin: globalPos, size: self.frame.size)
    }
    func click() {
        print("click on timer")
        GameScene.current!.timeOut()
        
    }
    func checkClick(touchPoint: CGPoint) -> Clickable? {
        let rect  = getRect()
        if (CGRectContainsPoint(rect, touchPoint)){
            return self
        }
        return nil
    }
    
    
}