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
            UIWaveButton0 = UIWaveButton(size: CGSize(width: 200, height: 50), position: CGPoint(x: 0, y: 50*i-25), wave:Wave())
            UIWaveButton0.zPosition=1
            UIWaveButton0.name="UIWaveButton"
            self.addChild(UIWaveButton0)
        }
        let UIBackground = SKSpriteNode(texture: nil, color: UIColor.darkGrayColor(), size: CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height/2))
        UIBackground.position=CGPoint(x: 0, y: UIScreen.mainScreen().bounds.height/4)
        UIBackground.zPosition = -1
        self.addChild(UIBackground)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}