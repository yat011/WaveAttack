//
//  Tornado.swift
//  WaveAttack
//
//  Created by yat on 25/11/2015.
//
//

import Foundation
import SpriteKit



class Tornado : GameObject{
    var sprite = SKSpriteNode()
    var fieldNode = SKFieldNode.springField()
    var timer = FrameTimer(duration: 10)
    override func getSprite() -> SKNode? {
        return sprite
    }
    override init() {
        super.init()
       sprite.size  = CGSize(width: 60, height: 80)
        var textures = [SKTexture]()
        for var i = 1; i <= 6 ; i++ {
           textures.append(SKTexture(imageNamed: "costume\(i)"))
        }
        sprite.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.1)))
        sprite.alpha = 0.6
        fieldNode.minimumRadius = 1
        fieldNode.strength = 0.1
        fieldNode.falloff = 1
        fieldNode.position = CGPoint(x: 0, y: 30)
        sprite.addChild(fieldNode)
        timer.addToGeneralUpdateList()
        timer.startTimer({
            Void in
            self.timer.removeFromGeneralUpdateList()
            self.gameLayer.removeGameObject(self)

        })
       gameLayer.startAttack()
    }
    override func deleteSelf() {
        super.deleteSelf()
        sprite.removeFromParent()
    }
    
    
}