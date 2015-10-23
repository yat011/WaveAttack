//
//  CharScene.swift
//  WaveAttack
//
//  Created by James on 23/10/15.
//
//

import Foundation
import SpriteKit

class CharScene:SKScene{
    var viewController:GameViewController?
    var prevScene:SKScene?
    var character:Character?
    override init(size:CGSize){
        
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}