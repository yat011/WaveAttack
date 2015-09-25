//
//  UIWave.swift
//  WaveAttack
//
//  Created by James on 21/9/15.
//
//

import Foundation
import SpriteKit

class UIWaveButton : UIButton {
    
    let pet:String = ""
    //let WaveData
    
    
     override init(size : CGSize , position : CGPoint){
        super.init(size: size, position: position)
        self.name="WaveButton"
        
        let tileTexture = UIWaveButtonTexture(texture: SKTexture(imageNamed: "box"), color: UIColor.clearColor(), size: self.size)
        self.addChild(tileTexture)
        self.addChild(tileTexture)
        self.addChild(tileTexture)
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