//
//  CharacterSlot.swift
//  WaveAttack
//
//  Created by James on 21/10/15.
//
//

import Foundation
import SpriteKit

class CharacterSlot:SKSpriteNode{
    var character:Character?
    init(character:Character?) {
        self.character=character
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSize(width: 50, height: 50))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}