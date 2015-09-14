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
    var sprite : GameSKShapeNode
    var energy : Double
    var direction : CGVector = CGVector(dx: 0, dy: 1)
    var speed : CGFloat = 10
    private var belongTo : [Medium] = []
    init(_ energy: Double, position pos : CGPoint) {
       
        self.energy = energy
        
        let rectNode = GameSKShapeNode(circleOfRadius: radius)
       
        
        rectNode.fillColor = SKColor.redColor()
        rectNode.name = GameObjectName.Packet.rawValue
        var tempRect = rectNode.frame
        
        tempRect = tempRect.rectByOffsetting(dx: -1 * rectNode.position.x, dy: -1 * rectNode.position.y)
        
      // rectNode.physicsBody = SKPhysicsBody(edgeLoopFromRect: tempRect)
        rectNode.physicsBody = SKPhysicsBody(circleOfRadius: radius)
       rectNode.physicsBody!.categoryBitMask = CollisionLayer.Packet.rawValue
        rectNode.physicsBody!.contactTestBitMask = CollisionLayer.GameBoundary.rawValue | CollisionLayer.Medium.rawValue
        rectNode.physicsBody!.affectedByGravity = false
        rectNode.physicsBody!.collisionBitMask = 0x0
        
        
        self.sprite = rectNode
       self.sprite.position = pos
        self.sprite.zPosition = 1.0
        super.init()
         rectNode.setGameObject(self)
        
    }
    func getBelongTo() -> Medium?{
        return belongTo.last
    }
    func popBelongTo() -> Medium?{
        return belongTo.removeLast()
    }
    func pushBelongTo(_ m: Medium)->(){
        belongTo.append(m)
    }
    
    
    override func getSprite() -> SKNode? {
        return self.sprite
    }
    
    override func update() {
        doMove()
        
    }
    
    
    func getMovement () -> CGVector {
       var speed: CGFloat = CGFloat((self.getBelongTo()?.propagationSpeed)!)
        self.direction.normalize()
        return CGVector(dx: self.direction.dx * speed, dy: self.direction.dy * speed)
        
    }
    
    func doMove(){
        
        sprite.runAction(SKAction.moveBy(getMovement() , duration: 0))
        
    }
    
    
    
    func changeMedium (from from : Medium? , to to : Medium?){
        print(from)
        print(to)
        if (from == nil){
            pushBelongTo(to!)
        }
        
        
        
    }
    
    func containsMedium ( medium : Medium) -> Bool {
        for each in belongTo {
            if (medium === each){
                return true
            }
        }
        return false
    }
    
}





