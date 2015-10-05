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
    var waveNode:SKShapeNode?=nil
    //let WaveData

    init(size : CGSize , position : CGPoint, wave:Wave){
        self.wave=wave
        super.init()
        self.name="WaveButton"
        self.position=position
        
        //self.maskNode = SKSpriteNode(texture: nil, color: UIColor.blackColor(), size: CGSize(width: 50, height: 50))
        //let tileTexture = UIWaveButtonTexture(texture: SKTexture(imageNamed: "box"), color: UIColor.clearColor(), size: size)
        waveNode=wave.getShape()
        print(waveNode)
        self.addChild(waveNode!)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     func scroll(dx : CGFloat){
        var newX = waveNode!.position.x + dx
        waveNode!.runAction(SKAction.moveToX(newX, duration: 0))
        print("dragging:"+newX.description)
    }
    
    /*
    override func getSprite() -> SKNode? {
        return sprite
    }
*/
}