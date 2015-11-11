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

    let radius : CGFloat = 8
    var physRadius :CGFloat = 2.5
    var sprite : GameSKSpriteNode? = nil
    var energy : CGFloat = 0

    var direction : CGVector = CGVector(dx: 0, dy: 1)
      // var speed : CGFloat = 10
    weak var gameLayer : GameLayer? = nil
    var deleted: Bool = false
    
    var forceDir:CGFloat = 1
    
    static let DELETED_EVENT = "deleted"
    static let energyThreshold: CGFloat = 2
    
    var belongTo : [Medium] = []
    var prevBelongTo : [Medium] = []
    static var texture : SKTexture? = nil
    
    
    init(_ energy: CGFloat, position pos : CGPoint, gameScene sc : GameScene) {
       super.init()
       initialize(energy, position: pos, gameScene: sc)
        
    }
    
    func initialize(energy: CGFloat, position pos : CGPoint, gameScene sc : GameScene){
        self.energy = energy
      
        var rectNode = GameSKSpriteNode(imageNamed: "packet")
        rectNode.size = CGSize(width: radius * 2 , height: radius * 2)
       // rectNode.fillColor = SKColor.whiteColor()
        //rectNode.strokeColor=SKColor.clearColor()
//        rectNode.lineWidth=0.0
        rectNode.colorBlendFactor = 1

        /*
        if texture == nil{
            var rectNode = GameSKShapeNode(circleOfRadius: radius)
            
            rectNode.fillColor = SKColor.whiteColor()
            rectNode.strokeColor=SKColor.clearColor()
            rectNode.lineWidth=0.0
            EnergyPacket.GameViewController.skView!.scene!
                .addChild(rectNode)
            
            //temp.hidden = true
            EnergyPacket.texture  = GameViewController.skView!.textureFromNode(rectNode)
            
            // temp.removeFromParent()
            //texture?.filteringMode = SKTextureFilteringMode.Nearest
            rectNode.removeFromParent()
        }
        var scale:CGFloat = 1
        print("\(totLen) vs \(texture!.size().width)")
        scale  = totLen / texture!.size().width
        if (UIScreen.mainScreen().scale == 2 && scale < 0.6){
            scale = 0.5
        }

        //   print(texture)
        var res = SKSpriteNode(texture: texture, size: CGSize(width: texture!.size().width * scale, height: texture!.size().height * scale))
        res.anchorPoint = CGPoint(x:0, y:0.5)

        */
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
        self.sprite!.position = pos
        // self.prevPoint = pos
        // self.prevDisplacement = CGVector (dx: 0, dy: 0)
        self.sprite!.zPosition = 1.0
        self.gameScene  = sc
        rectNode.color = getColor()
        //rectNode.fillColor = getColor()
        //rectNode.strokeColor = getColor()
        //rectNode.antialiased = false
         rectNode.setGameObject(self)
        
        // event
       // self.subscribeEvent(EnergyPacket.DELETED_EVENT, call: gameScene!.gameLayer!.removeGameObject)
        

    }
    
    
    
    
    
    func getColor () -> SKColor{
      /*  var r = (sin(self.energy) * 127 + 128) / 255
        var g = (sin( self.energy + 1) * 127 + 128) / 255
        var b = (sin(self.energy + 3 ) * 127 + 128) / 255
        print("\(r) \(g) \(b)")*/
        var brigthness : CGFloat = 1
        var hue = self.energy
        var newRadius = self.physRadius + hue/1000 * (self.radius - self.physRadius)
        
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
        //change Size
        self.sprite!.size = CGSize(width: 2*newRadius, height: 2*newRadius)
        
        
        return SKColor(hue: hue, saturation: 1, brightness: brigthness, alpha: 1)
        //return SKColor (red: r, green: g, blue: b, alpha: 1)
        
    }
    
    
    func getBelongTo() -> Medium?{
        return belongTo.last
    }
    func popBelongTo() -> Medium?{
        
        getBelongTo()!.removePacketRef(self)
        let res = belongTo.removeLast()
        getBelongTo()!.addPacketRef(self)
        return res
    }
    func pushBelongTo(m: Medium)->(){
        if (belongTo.count > 0){
            getBelongTo()!.removePacketRef(self)
        }

        belongTo.append(m)
        getBelongTo()!.addPacketRef(self)
    }
    
    
    override func getSprite() -> SKNode? {
        return self.sprite
    }
    
    override func update() {
        if deleted{
            //doMove()
            return
        }
        if (self.energy < EnergyPacket.energyThreshold){
            //destory self
            deleteSelf()
            return
        }
        if (!CGRectContainsPoint(gameScene!.packetArea!, sprite!.position)){ // out of area
           // print("delete self")
            deleteSelf()
            return
        }
        
        if (getBelongTo()! is DestructibleObject){
            var des = getBelongTo()! as! DestructibleObject
            des.calculateDamage(self)
            sprite!.color = getColor()
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
       // print(self.direction)
        return CGVector(dx: self.direction.dx * speed, dy: self.direction.dy * speed)
        
    }
    
    func doMove(){
         //sprite!.physicsBody!.velocity = getMovement()
        sprite!.physicsBody!.velocity = CGVector (dx: 0, dy: 0)
        sprite!.runAction(SKAction.moveBy(getMovement() , duration: 0))
      // ////print( sprite.physicsBody!.velocity)
       
        
        
    }
  
    
    func changeMedium (from from : Set<Medium> ,to : Set<Medium>, contact: [Medium : ContactInfo]){
    
        prevBelongTo.removeAll()
        prevBelongTo.appendContentsOf(belongTo)
       
       // //print (contact.count)
        /*
        if (checkValidCollision( contact.first!.1) == false ){ // not moving towards
            return
        }
*/
        let currentFrom = getBelongTo()
        for t in to{
            if (containsMedium(t) == false){
                addBelong(t)
            }
        }
        for f in from {
            removeFromBelong(from: f)
        }
      
        
        let resultTo = getBelongTo()
        
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
    private func doSpecificPhysics(from from : Medium? ,to : Medium?, contact: ContactInfo?){
       // _ = 1
        if (energy < EnergyPacket.energyThreshold){
            return
        }
        
        
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
         //   print(tranRatio)
            reflectRatio = 1 - tranRatio
        }
        let diff: CGFloat = CGFloat( abs( to!.collisionAbsorption - from!.collisionAbsorption))
        let energyAttenuation = diff * ( 1 + reflectRatio) + 5
        self.energy = self.energy - energyAttenuation
       // _ = self.energy * tranRatio
       
       
        if (self is Reflectable && reflectRatio > 0){
            let reflect = self as! Reflectable
            let rePacket = reflect.doReflection(from: from, to: to, contact: contact)!
            rePacket.energy = rePacket.energy * reflectRatio
            self.gameLayer!.addGameObject(rePacket)
            rePacket.sprite!.color = rePacket.getColor()
            
            
        }

        self.energy = self.energy * tranRatio
        
        
        
        cosine = nil
        
        self.sprite!.color = getColor()
       
    }
    
  
    
    
    
    
    func removeFromBelong (from from : Medium?){
        for i in 0...(belongTo.count - 1){
            if (belongTo[i] === from!){
                if (i == belongTo.count - 1){
                    getBelongTo()!.removePacketRef(self)
                    belongTo.removeAtIndex(i)
                    getBelongTo()!.addPacketRef(self)
                    return
                }
                belongTo.removeAtIndex(i)
 
               // justExit = true
                return
            }
        }
        
    }
    func addBelong(medium: Medium){
        let pos  = checkHighZIndex(medium)
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
    
    func removeSelf(){
        gameLayer!.removeGameObject(self)
    }
    
    override func deleteSelf () {
        sprite!.runAction( SKAction.fadeOutWithDuration(0.1), completion: self.removeSelf)
        getBelongTo()!.removePacketRef(self)
        deleted = true
       // gameLayer!.removeGameObject(self)
       // belongTo.removeAll()
        //prevBelongTo.removeAll()
        
    }
    
    
    
    
    
}





