//
//  UIWave.swift
//  WaveAttack
//
//  Created by James on 21/9/15.
//
//

import Foundation
import SpriteKit

class UIWaveButton : SKCropNode {
    var wave:Wave
    let pet:String = ""
    var waveShapeNode:SKShapeNode?=nil
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
        self.addChild(waveShapeNode!)
        let UIWaveButtonBackground=SKSpriteNode(texture: nil, color: UIColor.brownColor(), size: CGSize(width: 300, height: 50))
        UIWaveButtonBackground.zPosition = -1
        self.addChild(UIWaveButtonBackground)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     func scroll(dx : CGFloat){
        var newX = waveShapeNode!.position.x + dx
        if(newX < CGFloat(-wave.length*2)) {newX = newX + CGFloat(wave.length)}
        else if(newX > CGFloat(-wave.length)) {newX = newX - CGFloat(wave.length)}
        waveShapeNode!.runAction(SKAction.moveToX(newX, duration: 0))
        print("dragging:"+newX.description)
    }
}