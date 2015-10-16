//
//  ButtonUI.swift
//  WaveAttack
//
//  Created by yat on 8/10/2015.
//
//

import Foundation
import SpriteKit

class ButtonUI : SKSpriteNode, Clickable{
    
    var clickfunc :(()->())? = nil
    var label : SKLabelNode? = nil
    weak var gameScene: GameScene? = nil
    static func createButton ( rect :CGRect, text : String , onClick : (() -> ()) , gameScene : GameScene ) -> ButtonUI{
        var base = ButtonUI(color: SKColor.grayColor(), size: rect.size)
      //  var base = ButtonUI()
        //base.size = rect.size
        base.position = rect.origin
        base.clickfunc = onClick
        base.label = SKLabelNode(text: text)
        base.label!.fontSize = 16
      //  base.label!.position = CGPoint(x: rect.origin.x, y: rect.origin.y)
        base.label!.fontColor = SKColor.whiteColor()
        base.label!.horizontalAlignmentMode = .Center
        base.label!.verticalAlignmentMode = .Center
        base.label!.fontName = "Helvetica"
        base.zPosition = 20000
        base.label!.zPosition = 20001
        base.addChild(base.label!)
        base.gameScene = gameScene
        return base
    }
    
    
    func click(){
        if (self.scene != nil){
            clickfunc?()
        }
    }
    func getRect () -> CGRect{
        var globalPos = gameScene!.convertPoint(self.frame.origin, fromNode: self.parent!)
       // print (globalPos)
        return CGRect (origin: globalPos, size: self.frame.size)
    }
   
        
}