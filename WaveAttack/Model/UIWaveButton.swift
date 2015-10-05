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
    
    let pet:String = ""
    //let WaveData

    init(size : CGSize , position : CGPoint){
        super.init()
        self.name="WaveButton"
        self.position=position
        //self.maskNode = SKSpriteNode(texture: nil, color: UIColor.blackColor(), size: CGSize(width: 50, height: 50))
        //let tileTexture = UIWaveButtonTexture(texture: SKTexture(imageNamed: "box"), color: UIColor.clearColor(), size: size)
        let node:SKShapeNode=TextureGenerator.WaveToTexture()
        print(node)
        self.addChild(node)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    override func getSprite() -> SKNode? {
        return sprite
    }
*/
}