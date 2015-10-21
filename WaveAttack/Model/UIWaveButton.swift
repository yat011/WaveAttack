//
//  UIWave.swift
//  WaveAttack
//
//  Created by James on 21/9/15.
//
//

import Foundation
import SpriteKit

class UIWaveButton : SKCropNode,Draggable {
    var wave:Wave
    let pet:String = ""
    var waveShapeNode:SKNode?=nil
    //let WaveData

    init(size : CGSize , position : CGPoint, wave:Wave){
        self.wave=wave
        super.init()
        self.name="WaveButton"
        self.position=position
        
        //self.maskNode = SKSpriteNode(texture: nil, color: UIColor.blackColor(), size: CGSize(width: 50, height: 50))
        //let tileTexture = UIWaveButtonTexture(texture: SKTexture(imageNamed: "box"), color: UIColor.clearColor(), size: size)
        waveShapeNode=wave.getShape()
        waveShapeNode!.position.x=CGFloat(random()%wave.length)-CGFloat(wave.length*2)
        print(waveShapeNode)
        let path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddLineToPoint(path, nil, 300, 0)
        
        
        var boundary = SKShapeNode(rectOfSize: CGSize(width: 300, height: size.height))
        boundary.strokeColor = SKColor.blackColor()
       // boundary.position = CGPoint(x: -150, y:0)
        self.addChild(boundary)
        var dottedLine = SKShapeNode(path: CGPathCreateCopyByDashingPath(path, nil, 0, [5,5], 2)!)
        dottedLine.alpha = 0.5
        dottedLine.position = CGPoint(x: -150, y: 0)
        self.addChild(waveShapeNode!)
        self.addChild(dottedLine)
        let UIWaveButtonBackground=SKSpriteNode(texture: nil, color: UIColor.brownColor(), size: CGSize(width: 300, height: 50))
        UIWaveButtonBackground.zPosition = -1
        self.addChild(UIWaveButtonBackground)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scroll(dx : CGFloat, dy:CGFloat){
        var newX = waveShapeNode!.position.x + dx
        if(newX < CGFloat(-wave.length*2)) {newX = newX + CGFloat(wave.length)}
        else if(newX > CGFloat(-wave.length)) {newX = newX - CGFloat(wave.length)}
       // newX =  CGFloat(-wave.length)
        waveShapeNode!.runAction(SKAction.moveToX(newX, duration: 0))
        // print("dragging:"+newX.description)
    }
    func scroll(x : CGFloat, y:CGFloat){
        waveShapeNode!.runAction(SKAction.moveToX(x, duration: 0))
        // print("dragging:"+newX.description)
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
}