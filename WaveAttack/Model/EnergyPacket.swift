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
    var prevBelongTo : [Medium] = []
    init(_ energy: Double, position pos : CGPoint) {
       
        self.energy = energy
        
        var rectNode = GameSKShapeNode(circleOfRadius: radius)
       
        
        rectNode.fillColor = SKColor.redColor()
        rectNode.name = GameObjectName.Packet.rawValue
        var tempRect = rectNode.frame
        
        tempRect = tempRect.offsetBy(dx: -1 * rectNode.position.x, dy: -1 * rectNode.position.y)
        
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
        ////print(self.sprite.physicsBody!.allContactedBodies())
    }
    
    
    func getMovement () -> CGVector {
       let speed: CGFloat = CGFloat((self.getBelongTo()?.propagationSpeed)!)
        self.direction.normalize()
        return CGVector(dx: self.direction.dx * speed, dy: self.direction.dy * speed)
        
    }
    
    func doMove(){
        
        //sprite.runAction(SKAction.moveBy(getMovement() , duration: 0))
      // //print( sprite.physicsBody!.velocity)
        sprite.physicsBody!.velocity = getMovement()
    }
 

    
    func changeMedium (from from : Set<Medium> ,to to : Set<Medium>, contact: [Medium : SKPhysicsContact]){
    
        prevBelongTo.removeAll()
        prevBelongTo.appendContentsOf(belongTo)
        if ( contact.first!.1.contactNormal.dot(direction) >= 0 ){ // not moving towards
            return
        }
        var currentFrom = getBelongTo()
        for f in from {
            removeFromBelong(from: f)
        }
        for t in to{
          addBelong(t)
        }
        
        var resultTo = getBelongTo()
        
        if (resultTo === currentFrom){
            print("not change")
            //do nth
        }else{
            var c  = contact[resultTo!]
            if (c == nil){
                c = contact[currentFrom!]
            }
            doSpecificPhysics(from: currentFrom, to: resultTo, contact: c)
        }
        
        
        /*   //print(from)
        //print(to)
        if ( contact?.contactNormal .dot(direction) >= 0 ){ // not moving towards
            return 
        }
        var check : Int? =  nil
        if (from == nil){ // enter
            //from = getBelongTo()
           check = checkHighZIndex(to!)
            if (check == nil){
                doSpecificPhysics(from: getBelongTo(), to: to, contact: contact)
                pushBelongTo(to!)
            }else{
                belongTo.insert(to!, atIndex: check!)
            }
        
        }else if to == nil { // exit
            //check sth
            
            
            if (from! === belongTo.last!){
                doSpecificPhysics(from: from, to: belongTo[belongTo.count-2], contact: contact)
                popBelongTo()
              

            }else{
                removeFromBelong(from: from)
               
            }
           
        }else{ //object to object
            check = checkHighZIndex(to!)
            if (from! === belongTo.last!){
                doSpecificPhysics(from: from, to: to, contact: contact)
                popBelongTo()
            }else{
                removeFromBelong(from: from)
            }
            pushBelongTo(to!)
        }
        
        
        */
        
        
        
    }
    
    
    
    private func doSpecificPhysics(from from : Medium? ,to to : Medium?, contact: SKPhysicsContact?){
        if (self is Refractable && to != nil){
            
            let me = self as! Refractable
            me.doRefraction(from: from, to: to, contact: contact)
        }
    }
    
    
    func removeFromBelong (from from : Medium?){
        for i in 0...(belongTo.count - 1){
            if (belongTo[i] === from!){
                belongTo.removeAtIndex(i)
                return
            }
        }
    }
    func addBelong(medium: Medium){
        var pos  = checkHighZIndex(medium)
        if (pos != nil){
            belongTo.insert(medium, atIndex: pos!)
        }else{
            pushBelongTo(medium)
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
    
    func checkHighZIndex(medium : Medium) -> Int?{
        if (medium.zIndex >= getBelongTo()!.zIndex){
            return nil
        }else{
            
            for i in 0...(belongTo.count - 1){
                if (medium.zIndex < belongTo[i].zIndex ){
                    return i
                }
            }
            return nil
        }
        
    }
    
    func deleteSelf () {
        gameLayer?.removeGameObject(self)
        
    }
    
    
    
    
    
}





