//
//  HpLabel.swift
//  WaveAttack
//
//  Created by yat on 2/11/2015.
//
//

import Foundation
import SpriteKit
class HpLabel : SKLabelNode{
    var background : SKSpriteNode? = nil
    var max : CGFloat = 0
    init (rect: CGRect, max : CGFloat , current : CGFloat, belongTo : GameObject){
        super.init()
        //self.init(fontNamed: "Helvetica")
        self.fontName = "Helvetica"
        self.text =  String(format: "%.2f / %.2f", current, max)
        self.fontSize = 12
        self.verticalAlignmentMode = .Center
        self.horizontalAlignmentMode = .Center
       //print( self.calculateAccumulatedFrame())
        //print(self.frame)
        background = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: self.frame.size.width , height: self.frame.size.height))
        self.zPosition = 100000
        self.alpha = 0.6
        self.addChild(background!)
        self.max  = max
        //self.fontSize = 12
        self.position = rect.origin
        weak var wtemp = self
        belongTo.subscribeEvent(GameEvent.HpChanged.rawValue, call: {
            (sender : GameObject,any) -> () in
         
            
            guard wtemp != nil else {
                return
            }
            if (sender is DestructibleObject){
                let temp = sender as! DestructibleObject
                var val = temp.hp
                wtemp!.updateCurrentHp(val)
                
            }
        })
        
    }
    func updateCurrentHp(cur : CGFloat) {
        var current = cur
        if (current < 0){
            current = 0
        }
        
        
        self.text = String(format: "%.2f / %.2f", current, max)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}