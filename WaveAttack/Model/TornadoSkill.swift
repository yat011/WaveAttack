//
//  TornadoSkill.swift
//  WaveAttack
//
//  Created by yat on 25/11/2015.
//
//

import Foundation
import SpriteKit

class TornadoSkill: PlacableSkill{
    
    override func createIndicator() -> SKSpriteNode {
        var node = SKSpriteNode(imageNamed: "costume1")
        node.size = CGSize(width: 60, height: 80)
        node.colorBlendFactor = 1
        node.color = SKColor.blackColor()
        return node
    }
    override func getIndicatorPosition(pos: CGPoint) -> CGPoint {
        var res:CGPoint = pos
        res.y = gameLayer.ground!.frontY + 5
        return res
    }
    override func perform(pos: CGPoint, character: Character) {
        var sprite = Tornado()
        sprite.sprite.position = getIndicatorPosition(pos)
        
        gameLayer.addGameObject(sprite)
        
    }
    
}