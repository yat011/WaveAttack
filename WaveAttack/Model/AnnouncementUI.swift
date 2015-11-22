//
//  AnnouncementUI.swift
//  WaveAttack
//
//  Created by yat on 22/11/2015.
//
//

import Foundation
import SpriteKit


class AnnouncementUI : SKSpriteNode{
    
    var cropNode = SKCropNode()
    var cropMask:SKSpriteNode? = nil
    convenience init(){
        self.init(texture: SKTexture(imageNamed: "announcement"))
        self.size = CGSize(width: GameScene.current!.size.width, height: 50)
        self.addChild(cropNode)
        var cropMask = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: GameScene.current!.size.width - 90, height: 40))
        cropMask.position = CGPoint(x: 35, y: 0)
        self.cropMask = cropMask
        cropNode.maskNode = cropMask
        //cropNode.addChild(cropMask)
        
        self.hidden = true
    }
    func showTextLabel(text:String){
        self.hidden = false
        var label = SKLabelNode(text: text)
        label.fontSize = 18
        label.fontColor = SKColor.blackColor()
        label.horizontalAlignmentMode = .Left
        label.verticalAlignmentMode = .Center
        label.fontName = "Helvetica"
        label.position = CGPoint(x: cropMask!.position.x + cropMask!.size.width/2, y: 0)
        var actions = [SKAction.moveToX(0-label.frame.width - cropMask!.size.width/2, duration: 10)]
        label.runAction(SKAction.sequence(actions),completion:{
            Void in
            self.hidden = true
            })
        cropNode.addChild(label)
    }
    
}