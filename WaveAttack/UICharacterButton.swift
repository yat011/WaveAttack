//
//  UIButton.swift
//  WaveAttack
//
//  Created by James on 23/9/15.
//
//

import Foundation
import SpriteKit

class UICharacterButton : SKSpriteNode,Clickable {
    var character:Character?
    var stoke : SKShapeNode? = nil
    var mask : SKShapeNode? = nil
    init(size : CGSize , position : CGPoint, character:Character?){
        super.init(texture: character?.texture, color: UIColor.cyanColor(), size: size)
        var back = SKSpriteNode(color: SKColor.whiteColor(), size: size)
        
        back.zPosition = -100
        self.addChild(back)
        stoke = SKShapeNode(rectOfSize: size)
        
        stoke!.strokeColor = SKColor.yellowColor()
        stoke!.lineWidth = 3
        stoke!.zPosition = 1
        stoke!.hidden = true
        self.character=character
        self.addChild(stoke!)
        self.size = size
        self.position = position
        //self.sprite!.gameObject = self
        
        mask = SKShapeNode(rectOfSize: size)
        mask!.fillColor = SKColor.blackColor()
        mask!.alpha = 0.5
        mask!.zPosition = 2
        mask!.hidden = true
        self.addChild(self.mask!)
        
        guard character != nil else {return}
        
        character!.subscribeEvent(GameEvent.SkillReady.rawValue, call: self.ready)
        
        character!.subscribeEvent(GameEvent.SKillUsed.rawValue, call: self.notReady)
        
        character!.subscribeEvent(GameEvent.SKillPending.rawValue, call: self.selected)
    }
    func selected(obj:GameObject,nth:AnyObject?){
        self.stoke!.hidden = false
        self.mask!.hidden = false
    }
    func notReady(obj:GameObject,nth:AnyObject?){
        self.stoke!.hidden = true
        self.mask!.hidden = true
    }
    func ready(obj:GameObject,nth:AnyObject?){
        self.stoke!.hidden = false
        self.mask!.hidden = true
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getRect () -> CGRect{
   //  print(CGRect(origin: self.scene!.convertPoint(self.position, fromNode: self.parent!), size: self.size))
        //print(self.calculateAccumulatedFrame())
        var pos = self.scene!.convertPoint(self.position, fromNode: self.parent!)
        pos = CGPoint(x: pos.x - self.size.width/2 , y: pos.y - self.size.height/2)
        return CGRect(origin: pos, size: self.size)
    }
    func click(){
        print("clicked character button")
        character?.useSkill()
    }
    
    func ready(){
        
    }
}