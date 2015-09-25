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
        for i in 1...5
        {
            let UIWaveButton0 = UIWaveButton(size: CGSize(width: 200, height: 50), position: CGPoint(x: 0, y: 50*i-25))
            UIWaveButton0.name="WaveButton"
            self.addChild(UIWaveButton0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}