//
//  UIScene.swift
//  WaveAttack
//
//  Created by James on 21/9/15.
//
//

import Foundation
import SpriteKit

class UINode: SKNode{
    init(position : CGPoint, parent:SKScene){
        super.init()
        self.position = position
        self.name = "UINode"
        var UIWaveButton0:UIWaveButton
        let UIWaveButtonGroup=SKNode()
        UIWaveButtonGroup.name="UIWaveButtonGroup"
        for i in 1...5
        {
            UIWaveButton0 = UIWaveButton(size: CGSize(width: 200, height: 50), position: CGPoint(x: 0, y: 50*i-25), wave:Wave())
            UIWaveButton0.zPosition=1
            UIWaveButton0.name="UIWaveButton"
            UIWaveButtonGroup.addChild(UIWaveButton0)
        }
        self.addChild(UIWaveButtonGroup)
        /*
        var w=Wave.superposition((self.children[0] as! UIWaveButton).wave, d1: 10,
            w2: Wave.superposition((self.children[1] as! UIWaveButton).wave, d1: 175,
                w2: Wave.superposition((self.children[2] as! UIWaveButton).wave, d1: 222,
                    w2: Wave.superposition((self.children[3] as! UIWaveButton).wave, d1: 210, w2: (self.children[4] as! UIWaveButton).wave, d2: 111), d2: 70), d2: 99), d2:123)
        */
        
        
        
        let UIBackground = SKSpriteNode(texture: nil, color: UIColor.darkGrayColor(), size: CGSize(width: parent.size.width, height: parent.size.height/2))
        UIBackground.position=CGPoint(x: 0, y: parent.size.height/4)
        UIBackground.zPosition = -1
        self.addChild(UIBackground)
        //hollow texture for cropping
        
        let UIForeground = SKNode()
        UIForeground.name="UIForeground"
        UIForeground.zPosition=10
        self.addChild(UIForeground)
        
        var c = MathHelper.boundsToCGRect(-parent.size.width/2, x2: -150, y1: 0, y2: parent.size.height/2)
        var UIForeground0 = SKSpriteNode(texture: nil, color: UIColor.blackColor(), size: CGSize(width: c.width, height: c.height))
        UIForeground0.position=CGPoint(x: c.midX,y: c.midY)
        UIForeground.addChild(UIForeground0)
        c = MathHelper.boundsToCGRect(parent.size.width/2, x2: 150, y1: 0, y2: parent.size.height/2)
        UIForeground0 = SKSpriteNode(texture: nil, color: UIColor.blackColor(), size: CGSize(width: c.width, height: c.height))
        UIForeground0.position=CGPoint(x: c.midX,y: c.midY)
        UIForeground.addChild(UIForeground0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawSuperposition()->Wave{
        //superposition test
        let w=Wave.superposition((self.childNodeWithName("UIWaveButtonGroup")!.children[0] as! UIWaveButton).wave,d1: 0, w2: (self.childNodeWithName("UIWaveButtonGroup")!.children[1] as! UIWaveButton).wave, d2:0)
        w.normalize()
        let n=w.getShape()
        n.position=CGPoint(x:-150, y:300)
        self.addChild(n)
        return w
    }
}