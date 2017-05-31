//
//  ScoreFlashMsg.swift
//  WaveAttack
//
//  Created by yat on 17/11/2015.
//
//

import Foundation
import SpriteKit
class ScoreFlashMsg : SKLabelNode{
    
    convenience init(_ score: CGFloat ,_ obj: DestructibleObject){
        self.init(fontNamed:  "Helvetica")
        self.fontSize = 18
        self.text = String(format: "+ %.1f", score)
        self.fontColor = SKColor.blackColor()
        self.horizontalAlignmentMode = .Center
        self.zPosition = 10000000
        if obj.sprites.count == 0{
            self.runAction(SKAction.removeFromParent())
        }else{
        var pos = GameScene.current!.gameLayer!.convertPoint(obj.sprites[0].position, fromNode: obj.sprites[0].parent!)
        pos = pos + CGPoint(x: 0, y: obj.originSize!.height/2 )
        self.position = pos
        let actions = [ SKAction.moveByX(0, y: 50, duration: 1.5), SKAction.fadeOutWithDuration(1.5)]
        self.runAction(SKAction.sequence([SKAction.group(actions),SKAction.removeFromParent()]))
        }
    }
}