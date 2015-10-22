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
    init(size : CGSize , position : CGPoint, character:Character?){
        super.init(texture: character?.texture, color: UIColor.cyanColor(), size: size)
        var back = SKSpriteNode(color: SKColor.whiteColor(), size: size)
        back.zPosition = -100
        self.addChild(back)
        self.character=character
        
        self.size = size
        self.position = position
        //self.sprite!.gameObject = self
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
    
}