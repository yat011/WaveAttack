//
//  UIScene.swift
//  WaveAttack
//
//  Created by James on 21/9/15.
//
//

import Foundation
import SpriteKit

class UINode: SKNode,Draggable{
    init(position : CGPoint, parent:SKScene){
        super.init()
        self.position = position
        self.name = "UINode"
        
        var character0:Character
        var UIWaveButton0:UIWaveButton
        let UIWaveButtonGroup=SKNode()
        UIWaveButtonGroup.name="UIWaveButtonGroup"
//var temppos:[CGFloat] = [-438.4, -446.5, -424, -401, -453]
        for i in 0...4
        {
            //get team list
            character0=CharacterManager.getCharacterByID(CharacterManager.team[i])!
            UIWaveButton0 = UIWaveButton(size: CGSize(width: 200, height: 50), position: CGPoint(x: 0, y: 50*i+25), wave:character0.getWave())
            UIWaveButton0.zPosition=1
            UIWaveButton0.name="UIWaveButton"
//UIWaveButton0.waveShapeNode!.position = CGPoint(x: temppos[i],y:0)
            UIWaveButtonGroup.addChild(UIWaveButton0)
        }
        self.addChild(UIWaveButtonGroup)
        
        
        var UICharacterButton0:UICharacterButton
        let UICharacterButtonGroup=SKNode()
        UICharacterButtonGroup.name="UICharacterButtonGroup"
        for i in 0...4
        {
            UICharacterButton0 = UICharacterButton(size: CGSize(width: 30, height: 30), position: CGPoint(x:-150-30/2 , y: 50*i+25), character:nil)
            UICharacterButton0.zPosition=999
            UICharacterButton0.name="UICharacterButton0"
            UICharacterButtonGroup.addChild(UICharacterButton0)
        }
        self.addChild(UICharacterButtonGroup)
        
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
        let w0=(self.childNodeWithName("UIWaveButtonGroup")!.children[0] as! UIWaveButton)
        let w1=(self.childNodeWithName("UIWaveButtonGroup")!.children[1] as! UIWaveButton)
        let w2=(self.childNodeWithName("UIWaveButtonGroup")!.children[2] as! UIWaveButton)
        let w3=(self.childNodeWithName("UIWaveButtonGroup")!.children[3] as! UIWaveButton)
        let w4=(self.childNodeWithName("UIWaveButtonGroup")!.children[4] as! UIWaveButton)
        var d0 = (w0.waveShapeNode?.position.x)!
        d0 = -d0+750
        var d1 = (w1.waveShapeNode?.position.x)!
        d1 = -d1+750
        var d2 = (w2.waveShapeNode?.position.x)!
        d2 = -d2+750
        var d3 = (w3.waveShapeNode?.position.x)!
        d3 = -d3+750
        var d4 = (w4.waveShapeNode?.position.x)!
        d4 = -d4+750
        print(w0.waveShapeNode?.position.x)
        
        var w=Wave.superposition(w0.wave,d1: Int(d0),
            w2: Wave.superposition(w1.wave,d1: Int(d1),
                w2: Wave.superposition(w2.wave,d1: Int(d2),
                    w2: Wave.superposition(w3.wave,d1: Int(d3),
                        w2: w4.wave, d2: Int(d4)), d2:0), d2:0), d2:0)
        //wave displacement check
        //w=Wave.superposition(w0.wave,d1: Int(d0),w2: w0.wave,d2: Int(d0))
        w.normalize()
        let n=w.getShape()
        n.position=CGPoint(x:-150, y:300)
        self.addChild(n)
        return w
    }
    
    func checkClick(touchPoint : CGPoint)-> Clickable?{
        let rect  = getRect()
        if (CGRectContainsPoint(rect, touchPoint)){
            return self
        }
        return nil
    }
    func getRect () -> CGRect{
        return self.calculateAccumulatedFrame()
    }
    func click(){
        
    }
    func scroll(dx:CGFloat, dy:CGFloat){
        let newY = self.position.y + dy
        self.runAction(SKAction.moveToY(newY, duration: 0))
    }
    func scroll(x:CGFloat, y:CGFloat){
        self.runAction(SKAction.moveToY(y, duration: 0))
    }
}