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
    var resultantWaveShape: SKNode? = nil
    init(position : CGPoint, parent:GameScene){
        super.init()
        self.position = position
        self.name = "UINode"
        
        var character0:Character
        var UIWaveButton0:UIWaveButton
        let UIWaveButtonGroup=SKNode()
        UIWaveButtonGroup.name="UIWaveButtonGroup"
        for i in 0...4
        {
            //get team list
            character0=CharacterManager.getCharacterByID(CharacterManager.team[i])!
            UIWaveButton0 = UIWaveButton(size: CGSize(width: 200, height: 50), position: CGPoint(x: 0, y: 50*i+25), wave:character0.getWave())
            UIWaveButton0.zPosition=1
            UIWaveButton0.name="UIWaveButton"
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
            parent.addClickable(GameStage.Superposition, UICharacterButton0)
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
        //superposition test
        let w0=(self.childNodeWithName("UIWaveButtonGroup")!.children[0] as! UIWaveButton)
        let w1=(self.childNodeWithName("UIWaveButtonGroup")!.children[1] as! UIWaveButton)
        let w2=(self.childNodeWithName("UIWaveButtonGroup")!.children[2] as! UIWaveButton)
        let w3=(self.childNodeWithName("UIWaveButtonGroup")!.children[3] as! UIWaveButton)
        let w4=(self.childNodeWithName("UIWaveButtonGroup")!.children[4] as! UIWaveButton)
        print(w0.waveShapeNode?.position.x)
        
        let w=Wave.superposition(w0.wave,d1: Int((w0.waveShapeNode?.position.x)!+750),
            w2: Wave.superposition(w1.wave,d1: Int((w1.waveShapeNode?.position.x)!+750),
                w2: Wave.superposition(w2.wave,d1: Int((w2.waveShapeNode?.position.x)!+750),
                    w2: Wave.superposition(w3.wave,d1: Int((w3.waveShapeNode?.position.x)!+750), w2: w4.wave, d2: Int((w4.waveShapeNode?.position.x)!+750)), d2:0), d2:0), d2:0)
            
        //let w=Wave.superposition(w0.wave,d1: Int((w0.waveShapeNode?.position.x)!+750),w2: w1.wave,d2: Int((w1.waveShapeNode?.position.x)!+750))
        w.normalize()
        let n=w.getShape()
        n.position=CGPoint(x:-150, y:300)
        if (self.resultantWaveShape != nil){
            self.resultantWaveShape!.removeFromParent()
        }else{
            let path:CGMutablePathRef=CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 0, 0)
            CGPathAddLineToPoint(path, nil, 300, 0)
            var dottedLine = SKShapeNode(path: CGPathCreateCopyByDashingPath(path, nil, 0, [5,5], 2)!)
            dottedLine.alpha = 0.5
            dottedLine.position = CGPoint(x: -150, y: 300)
            self.addChild(dottedLine)
        
        }
        self.resultantWaveShape = n
        self.addChild(self.resultantWaveShape!)
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