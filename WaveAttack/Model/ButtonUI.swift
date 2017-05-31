//
//  ButtonUI.swift
//  WaveAttack
//
//  Created by yat on 8/10/2015.
//
//

import Foundation
import SpriteKit

class ButtonUI : SKSpriteNode,Interactable ,Clickable{
    
    var clickfunc :(()->())? = nil
    var label : SKLabelNode? = nil
    weak var gameScene: GameScene? = nil
    
    convenience init( rect :CGRect, text : String , onClick : (() -> ()) , gameScene : GameScene? ){
        self.init(color: SKColor.grayColor(), size: rect.size)
        position = rect.origin
        clickfunc = onClick
        label = SKLabelNode(text: text)
        label!.fontSize = 16
        //  base.label!.position = CGPoint(x: rect.origin.x, y: rect.origin.y)
        label!.fontColor = SKColor.whiteColor()
        label!.horizontalAlignmentMode = .Center
        label!.verticalAlignmentMode = .Center
        label!.fontName = "Helvetica"
        zPosition = 20000
        label!.zPosition = 20001
        addChild(label!)
        self.gameScene = gameScene
    }
    
    
    static func createButton ( rect :CGRect, text : String , onClick : (() -> ()) , gameScene : GameScene? ) -> ButtonUI{
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
    
    func checkTouch(touch:UITouch)->Bool{
        return CGRectContainsPoint(MathHelper.nodeToCGRect(self),touch.locationInNode(self.parent!))
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
   
    func getClass()->String{
        return "ButtonUI"
    }
        
}