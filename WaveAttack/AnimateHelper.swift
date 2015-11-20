//
//  AnimateHelper.swift
//  WaveAttack
//
//  Created by yat on 20/11/2015.
//
//

import Foundation
import SpriteKit
class AnimateHelper{
    
    static func animateFlashEffect (node :SKNode, duration : CGFloat, completion: (()->())?){
        var actions = [SKAction.fadeAlphaTo(0.6, duration: 0.25), SKAction.fadeAlphaTo(1, duration: 0.25)]
        var count = Int(duration/0.5 + 0.5)
        if completion != nil{
            node.runAction(SKAction.repeatAction(SKAction.sequence(actions), count: count),completion : completion!)
        }else{
            node.runAction(SKAction.repeatAction(SKAction.sequence(actions), count: count))
        }
    
    }
    
}