//
//  MeterSkill.swift
//  WaveAttack
//
//  Created by yat on 25/11/2015.
//
//

import Foundation
import SpriteKit

class MeterSkill: PlacableSkill{
    
    override func createIndicator() -> SKSpriteNode {
       var node = SKSpriteNode(imageNamed: "45arrow")
        node.size = CGSize(width: 40, height: 40)
        node.colorBlendFactor = 1
        node.color = SKColor.blackColor()
        return node
    }
    override func getIndicatorPosition(pos: CGPoint) -> CGPoint {
        var res:CGPoint = pos
        res.y = 300
        return res
    }
    override func perform(pos: CGPoint, character: Character) {
       var meter = Meterorolite()
        
        meter.spawnInit(pos)
        print(meter.sprite.position)
        gameLayer.addGameObject(meter)
    }
    
}