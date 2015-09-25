//
//  UIWaveButtonTexture.swift
//  WaveAttack
//
//  Created by James on 25/9/15.
//
//

import Foundation
import SpriteKit
class UIWaveButtonTexture:SKSpriteNode
{
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.name="WaveButtonTexture"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}