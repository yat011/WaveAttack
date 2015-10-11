//
//  UIButton.swift
//  WaveAttack
//
//  Created by James on 23/9/15.
//
//

import Foundation
import SpriteKit

class UIButton : SKSpriteNode {
    
    init(size : CGSize , position : CGPoint){
        super.init(texture: nil, color: UIColor.cyanColor(), size: size)

        
        self.size = size
        self.position = position
        //self.sprite!.gameObject = self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}