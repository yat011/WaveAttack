//
//  EnergyPacket.swift
//  WaveAttack
//
//  Created by yat on 11/9/2015.
//
//

import Foundation
import SpriteKit

class EnergyPacket : GameObject{
    let radius : CGFloat = 5;
    var sprite : SKShapeNode
    var energy : Double
    var direction : CGVector = CGVector(dx: 0, dy: 1)
    var speed : CGFloat = 5
    
    init(_ energy: Double, position pos : CGPoint) {
       
        self.energy = energy
        
        let rectNode = SKShapeNode(circleOfRadius: radius)
        rectNode.fillColor = SKColor.redColor()
        rectNode.name="redRect"
       // var tempRect = rectNode.frame
       // tempRect = tempRect.rectByOffsetting(dx: -1 * rectNode.position.x, dy: -1 * rectNode.position.y)
        
      //  rectNode.physicsBody = SKPhysicsBody(edgeLoopFromRect: tempRect)
            
       // rectNode.physicsBody!.categoryBitMask = 1
        self.sprite = rectNode
       self.sprite.position = pos
        super.init()
    }
    
    override func getSprite() -> SKNode? {
        return self.sprite
    }
    
    override func update() {
        doMove()
    }
    
    
    func doMove(){
        
        sprite.runAction(SKAction.moveBy(direction , duration: 0))
        
    }
    
}

