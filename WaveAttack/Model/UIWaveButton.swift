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
    
     override init(size : CGSize , position : CGPoint){
        super.init(size: size, position: position)
        self.texture = SKTexture(imageNamed: "box")
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