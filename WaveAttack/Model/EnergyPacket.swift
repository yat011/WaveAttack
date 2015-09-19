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
    let radius : CGFloat = 5
    var physRadius :CGFloat = 5
    var sprite : GameSKShapeNode
    var energy : CGFloat
    var direction : CGVector = CGVector(dx: 0, dy: 1)
      // var speed : CGFloat = 10
    weak var gameLayer : GameLayer? = nil
   // weak var spawnAt :
  //  var prevPoint : CGPoint
  //  var prevDisplacement : CGVector
 //   var lastContactInfo : ContactInfo? = nil
    //var lastPosition : CGPoint? = nil
   // var lastDirection : CGVector? = nil
   // var lastContains : Bool? = nil
  //  var justExit : Bool = false
    static let energyThreshold: CGFloat = 5
    
    var belongTo : [Medium] = []
    var prevBelongTo : [Medium] = []
    init(_ energy: CGFloat, position pos : CGPoint) {
       
        self.energy = energy
        
        var rectNode = GameSKShapeNode(circleOfRadius: radius)
       
        
        
        rectNode.name = GameObjectName.Packet.rawValue
        var tempRect = rectNode.frame
        
        tempRect = tempRect.offsetBy(dx: -1 * rectNode.position.x, dy: -1 * rectNode.position.y)
        
      // rectNode.physicsBody = SKPhysicsBody(edgeLoopFromRect: tempRect)
        rectNode.physicsBody = SKPhysicsBody(circleOfRadius: physRadius)
       
       rectNode.physicsBody!.categoryBitMask = CollisionLayer.Packet.rawValue
        rectNode.physicsBody!.contactTestBitMask = CollisionLayer.GameBoundary.rawValue | CollisionLayer.Medium.rawValue
        rectNode.physicsBody!.affectedByGravity = false
        rectNode.physicsBody!.allowsRotation = false
        rectNode.physicsBody!.collisionBitMask = 0x0
        rectNode.physicsBody!.linearDamping = 0
        rectNode.physicsBody!.usesPreciseCollisionDetection = true
        
        self.sprite = rectNode
       self.sprite.position = pos
       // self.prevPoint = pos
       // self.prevDisplacement = CGVector (dx: 0, dy: 0)
        self.sprite.zPosition = 1.0
        super.init()
        rectNode.fillColor = getColor()
         rectNode.setGameObject(self)
        
    }
    
    func getColor () -> SKColor{
      /*  var r = (sin(self.energy) * 127 + 128) / 255
        var g = (sin( self.energy + 1) * 127 + 128) / 255
        var b = (sin(self.energy + 3 ) * 127 + 128) / 255
        print("\(r) \(g) \(b)")*/
        var brigthness : CGFloat = 1
        var hue = self.energy
        if (hue > 1000) {
            brigthness = hue - 1000
            if (brigthness < 1000){
                brigthness = cos( brigthness * 1 / 1000 * 3.1415926 / 2 )
            }else{
                brigthness = 0
            }
            hue = 1
            
        }else{
            hue = hue/1000
        }
        hue = hue * 0.85
        
        return SKColor(hue: hue, saturation: 1, brightness: brigthness, alpha: 1)
        //return SKColor (red: r, green: g, blue: b, alpha: 1)
        
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
            return
        }
        if (!CGRectContainsPoint(gameLayer!.gameArea, sprite.position)){ // out of area
            print("delete self")
            deleteSelf()
            return
        }
        
        if (getBelongTo()! is DestructibleObject){
            var des = getBelongTo()! as! DestructibleObject
            des.calculateDamage(self)
            sprite.fillColor = getColor()
        }
        
        
        doMove()
       /*
        if (self.sprite.position == prevPoint){
            
        }else{
       //     //print("position \(self.sprite.position) - \(prevPoint)")
            prevDisplacement = self.sprite.position - prevPoint
        }
        prevPoint = sprite.position
*/
        //////print(self.sprite.physicsBody!.allContactedBodies())
    }
    
    
    func getMovement () -> CGVector {
       let speed: CGFloat = CGFloat((self.getBelongTo()?.propagationSpeed)!)
       
        self.direction.normalize()
        return CGVector(dx: self.direction.dx * speed, dy: self.direction.dy * speed)
        
    }
    
    func doMove(){
         sprite.physicsBody!.velocity = CGVector(dx: 0,dy: 0)
        sprite.runAction(SKAction.moveBy(getMovement() , duration: 0))
      // ////print( sprite.physicsBody!.velocity)
       
        
        
    }
    /*func checkValidCollision( contact : SKPhysicsContact) -> Bool{
        
        var contactNor = contact.contactNormal
   
        
        var pos = self.sprite.position + sprite.parent!.position
      //  //print (pos)
        ////print (contact.contactPoint)
        //print("check")
     //   var tprev = prevPoint + sprite.parent!.position
        var toPacket: CGVector = pos - contact.contactPoint
        //print(pos)
        //print (toPacket.dot(contactNor))
    /*
        toPacket = tprev - contact.contactPoint
        //print(tprev)
        //print (toPacket.dot(contactNor))
        
        //print (prevDisplacement)
       
        if ( prevDisplacement.dot(contactNor) > 0) {
            contactNor = -1 * contactNor
        }
    */
               
        if (contactNor.dot(direction) <= 0){
            return true
        }else{
            return false
        }
        return false
    }

    */
    func changeMedium (from from : Set<Medium> ,to to : Set<Medium>, contact: [Medium : ContactInfo]){
    
        prevBelongTo.removeAll()
        prevBelongTo.appendContentsOf(belongTo)
       
       // //print (contact.count)
        /*
        if (checkValidCollision( contact.first!.1) == false ){ // not moving towards
            return
        }
*/
        var currentFrom = getBelongTo()
        for f in from {
            removeFromBelong(from: f)
        }
        for t in to{
          addBelong(t)
        }
        
        var resultTo = getBelongTo()
        
        if (resultTo === currentFrom){
            //print("not change")
            //do nth
        }else{
            var c  = contact[resultTo!]
            if (c == nil){
                c = contact[currentFrom!]
            }
            doSpecificPhysics(from: currentFrom, to: resultTo, contact: c)
        }
        
        
        /*   ////print(from)
        ////print(to)
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
    //temp var
    var refractive : CGFloat = 0
    var refractiveRatio : CGFloat = 0
    var cosine : CGFloat? = nil
    
    
    //
    private func doSpecificPhysics(from from : Medium? ,to to : Medium?, contact: ContactInfo?){
        var rate = 1
        refractive = CGFloat( from!.propagationSpeed / to!.propagationSpeed)
        refractiveRatio = 1 / refractive
        
        var normal = contact!.contactNormal
        normal.normalize()
        self.direction.normalize()
        cosine = -1 * self.direction.dot(normal)
        var tranRatio: CGFloat = 0
        var reflectRatio: CGFloat = 1
        if (self is Refractable && to != nil){

            let me = self as! Refractable
            tranRatio = me.doRefraction(from: from, to: to, contact: contact)
            print(tranRatio)
            reflectRatio = 1 - tranRatio
        }
        var diff: CGFloat = CGFloat( abs( to!.collisionAbsorption - from!.collisionAbsorption))
        var energyAttenuation = diff * ( 1 + reflectRatio)
        self.energy = self.energy - energyAttenuation
        
        
        if (self is Reflectable){
            let reflect = self as! Reflectable
            let rePacket = reflect.doReflection(from: from, to: to, contact: contact)!
            rePacket.energy = rePacket.energy * reflectRatio
            self.gameLayer!.addGameObject(rePacket)
            rePacket.sprite.fillColor = rePacket.getColor()
            
            
        }
        
        self.energy = self.energy * tranRatio
        cosine = nil
        
        self.sprite.fillColor = getColor()
        
    }
    
  
    
    
    
    
    func removeFromBelong (from from : Medium?){
        for i in 0...(belongTo.count - 1){
            if (belongTo[i] === from!){
                belongTo.removeAtIndex(i)
               // justExit = true
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
        gameLayer!.removeGameObject(self)
       // belongTo.removeAll()
        //prevBelongTo.removeAll()
        
    }
    
    
    
    
    
}





