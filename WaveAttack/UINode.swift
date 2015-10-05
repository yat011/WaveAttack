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
        self.name = "UINode"
        var UIWaveButton0:UIWaveButton
        for i in 1...5
        {
            UIWaveButton0 = UIWaveButton(size: CGSize(width: 200, height: 50), position: CGPoint(x: 0, y: 50*i-25))
            UIWaveButton0.zPosition=1
            self.addChild(UIWaveButton0)
        }
        self.addChild(SKSpriteNode(texture: nil, color: UIColor.redColor(), size: CGSize(width: 300, height: 300)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}