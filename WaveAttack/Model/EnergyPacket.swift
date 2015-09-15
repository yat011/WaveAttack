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
   // var speed : CGFloat = 10
    weak var gameLayer : GameLayer? = nil
   // weak var spawnAt :
    
    static let energyThreshold: Double = 5
    
    var belongTo : [Medium] = []
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
        rectNode.physicsBody!.linearDamping = 0
        
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
        if (self.energy < EnergyPacket.energyThreshold){
            //destory self
            deleteSelf()
        }
        
        
        doMove()
        print(self.sprite.physicsBody!.allContactedBodies())
    }
    
    
    func getMovement () -> CGVector {
       var speed: CGFloat = CGFloat((self.getBelongTo()?.propagationSpeed)!)
        self.direction.normalize()
        return CGVector(dx: self.direction.dx * speed, dy: self.direction.dy * speed)
        
    }
    
    func doMove(){
        
        //sprite.runAction(SKAction.moveBy(getMovement() , duration: 0))
      // print( sprite.physicsBody!.velocity)
        sprite.physicsBody!.velocity = getMovement()
    }
    
    
    
    func changeMedium (var from from : Medium? ,var to to : Medium?, contact: SKPhysicsContact?){
        print(from)
        print(to)
        if (from == nil){
            //from = getBelongTo()
            doSpecificPhysics(from: getBelongTo(), to: to, contact: contact)
            pushBelongTo(to!)
        
        }else if to == nil {
            //check sth
            
            if (from! === belongTo.last!){
                doSpecificPhysics(from: from, to: belongTo[belongTo.count-2], contact: contact)
                popBelongTo()
              

            }else{
                removeFromBelong(from: from)
            }
           
        }else{ //object to object
            if (from! === belongTo.last!){
                doSpecificPhysics(from: from, to: to, contact: contact)
                popBelongTo()
            }else{
                removeFromBelong(from: from)
            }
            pushBelongTo(to!)
        }
        
        
        
        
        
        
    }
    
    private func doSpecificPhysics(var from from : Medium? ,var to to : Medium?, contact: SKPhysicsContact?){
        if (self is Refractable && to != nil){
            print("I can refract")
            var me = self as! Refractable
            me.doRefraction(from: from, to: to, contact: contact)
        }
    }
    
    
    private func removeFromBelong (from from : Medium?){
        for i in 0...(belongTo.count - 1){
            if (belongTo[i] === from!){
                belongTo.removeAtIndex(i)
                return
            }
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
    
    func deleteSelf () {
        gameLayer?.removeGameObject(self)
        
    }
    
    
    
    
    
}





