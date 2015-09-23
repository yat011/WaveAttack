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
    init(position : CGPoint){
        super.init()
        self.position = position
        let UIWaveButton1 = UIWaveButton(size: CGSize(width: 500, height: 500), position: CGPoint(x: 0, y: 0))
        self.addChild(UIWaveButton1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}