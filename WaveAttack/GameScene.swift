//
//  GameScene.swift
//  WaveAttack
//
//  Created by yat on 11/9/2015.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

import SpriteKit

enum CollisionLayer : UInt32 {
    case GameBoundary = 0x1
    case Packet = 0x2
    case Medium = 0x4
}
enum GameObjectName : String{
    case Packet = "Packet"
    case GameBoundary = "boundary"
    case Medium = "Medium"
}


enum GameStage {
    case Superposition, Attack
}

enum TouchType {
    case gameArea
}

class GameScene: SKScene , SKPhysicsContactDelegate{
   
    var gameLayer :GameLayer
    var infoLayer = SKNode()
    var controlLayer : SKShapeNode = SKShapeNode()
    var currentStage : GameStage = GameStage.Superposition
    var contactQueue = Array<SKPhysicsContact>()
    var endContactQueue  = [SKPhysicsContact]()
    var contactMap = [EnergyPacket : ContactContainer]()
    var playRect : CGRect? = nil
    
    
    
   // let fixedFps : Double = 30
    var lastTimeStamp : CFTimeInterval = -100
   // var updateTimeInterval : Double
    override init(size: CGSize) {
        let ph: CGFloat = size.height / 2
        let pPos = CGPoint(x: 0, y : ph)
        var psize  = CGSize(width: size.width, height: size.height / 2)
        playRect  = CGRect(origin: pPos, size: psize)
       gameLayer = GameLayer(size: psize)
        gameLayer.position = pPos
        
        //updateTimeInterval = 1.0 / fixedFps
        super.init(size: size)
        
        backgroundColor = SKColor.whiteColor()
      
        
       initGameLayer()
        initControlLayer()
      //  addObjectsToNode(gameLayer, attackPhaseObjects)
       self.addChild(gameLayer)
        self.addChild(controlLayer)
        self.addChild(infoLayer)
        
        currentStage = GameStage.Attack
        physicsWorld.contactDelegate = self
    }

  
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initGameLayer() -> (){
     
        
        // add boundary
        
     /*   let phys  = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height / 2)  )
        phys.categoryBitMask = CollisionLayer.GameBoundary.rawValue
        
        gameLayer.physicsBody = phys
*/
       // var p1 = NormalEnergyPacket(100, position: CGPoint(x: 0, y: 50))
       // attackPhaseObjects.append(p1)
        for i in 6...6  {
            var tempx: CGFloat = (self.size.width - CGFloat(20)) / 10.0
            tempx = tempx * CGFloat(i) + 10
            
            let p1 = NormalEnergyPacket(2000, position: CGPoint(x: tempx + 1.5, y: 50))
            p1.direction = CGVector(dx: 0, dy: 1)
            p1.gameLayer = gameLayer
            p1.pushBelongTo(gameLayer.background!)
          gameLayer.addGameObject(p1)
            

        }

        
    }
    
    func initControlLayer() -> (){
        controlLayer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height / 2) )
        controlLayer.fillColor = SKColor.blueColor()
        controlLayer.zPosition = 100
        
        let UIN = UINode(position: CGPoint(x: 100,y: 0))
        self.addChild(UIN)
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
     //   ////print("contact")
        ////print ("A : \(contact.bodyA.node!.name) #\(unsafeAddressOf(contact.bodyA.node!)) , B : \(contact.bodyB.node!.name) #\(unsafeAddressOf(contact.bodyB.node!))")
       // self.contactQueue.append(contact)
       //     ////print (contact.contactPoint)
     //////print(contact.contactNormal)
        
    
        
        
        
        
        if ( tryFindEnergyPacket(contact.bodyA.node, other: contact.bodyB.node, contact: contact) == true){
            return
        }else if (tryFindEnergyPacket(contact.bodyB.node, other: contact.bodyA.node, contact: contact) == true){
            return
        }
        
        
        
    }
    
    func validateIncidence (packet : EnergyPacket, _ medium : Medium,_ contact: ContactInfo, exit exit: Bool) -> Bool{
        
        ////print(medium.path)
        ////print(CGPathContainsPoint(medium.path, nil,CGPoint(x: 0, y: 0) , true))
        //print (contact.contactNormal)
        var conPos = medium.getSprite()!.convertPoint(packet.sprite.position, fromNode: gameLayer)
        // //print(CGPathContainsPoint(medium.path, nil,temp , true))
        var toward: CGVector = contact.contactPoint - (packet.sprite.position + gameLayer.position)
        toward.normalize()
        var contactPt = medium.getSprite()!.convertPoint(contact.contactPoint, fromNode: self)
        
       /*
        if(exit == false){
            
        
    
            print("contactPt:\(CGPathContainsPoint(medium.path, nil, contactPt, true)) pos:\(CGPathContainsPoint(medium.path, nil, conPos, true)) \(contact.contactNormal.dot(packet.direction))|| \(contact.contactNormal.dot(toward))|| contactPt \(contactPt) pos\(conPos) || vec \(packet.sprite.physicsBody!.velocity) || normal: \(contact.contactNormal) toward:\(toward)" )
 
            
            if (contact.contactNormal.dot(packet.direction) > 0 ){
               // print (packet.sprite.physicsBody!.allContactedBodies())
                return false
            }
        }
*/
        //print (toward.dot(packet.direction))
       
        if (exit){
            if (CGPathContainsPoint(medium.path, nil, conPos, true)==false){ //some fix
                contact.contactNormal = -1 * contact.contactNormal
            }
        }else{
            if (CGPathContainsPoint(medium.path, nil, conPos, true)==true){ //some fix
                contact.contactNormal = -1 * contact.contactNormal
            }
        }
        if (contact.contactNormal.dot(packet.direction) > 0 ){
            return false
        }else{
            return true
        }
       
        
        
       /*
        if (exit == true){
            var dot = packet.direction.dot(contact.contactNormal)
            if (dot < 0){
                
                if (CGPathContainsPoint(medium.path, nil, conPos, true)){ // not valid
                    packet.lastContactInfo = contact
                    packet.lastContains = true
                    packet.lastDirection = packet.direction
                    packet.lastPosition = packet.sprite.position
                    
                    return true
                }else{
                    fatalError("bug")
                    return false
                }
            }else if dot > 0 {
                if (CGPathContainsPoint(medium.path, nil, conPos, true)){ // not valid
                    return false
                }else{
                    fatalError("bug")
                    return false
                }
            }else {
                return false
            }
            
        }else{ // enter
            var dot = packet.direction.dot(contact.contactNormal)
          
            if (dot < 0){
                if (CGPathContainsPoint(medium.path, nil, conPos, true)){ // not valid
                 //   fatalError("bug")
                    return false
                }else{
                    packet.lastContactInfo = contact
                    packet.lastContains = false
                    packet.lastDirection = packet.direction
                    packet.lastPosition = packet.sprite.position
                 /*
                    if (packet.justExit ){
                        print("enter again")
                    }
*/
                    return true
                }
            }else if dot > 0 {
                if (CGPathContainsPoint(medium.path, nil, conPos, true)){ // not valid
                    //print("bug")
                    //fatalError("bug")
                    return false
                }else{
                    
                  
                    
                    //contact.contactNormal =  -1 * contact.contactNormal
                    return false
                    
                }
            }else {
                return false
            }
            

        }
*/
        return false
    }
    
    
    func tryFindEnergyPacket(sk : SKNode?, other other : SKNode?, contact nativeContact :SKPhysicsContact) -> Bool {
        var contact = ContactInfo(nativeContact)
        var packet: EnergyPacket? = nil
        if (sk is HasGameObject){
            let has = sk as! HasGameObject?
            ////print ("gameObject : \(has?.gameObject)")
            if ( has?.gameObject is EnergyPacket){
                packet = has!.gameObject as! EnergyPacket
        
                
                
                if (other!.name == GameObjectName.GameBoundary.rawValue){ // out of area
                    //out of bound
                    if (contactMap[packet!] != nil){
                        contactMap[packet!]!.outOfArea = true
                    }else{
                         let temp2 = ContactContainer()
                        temp2.outOfArea = true
                        contactMap[packet!] = temp2
                        
                    }
                    return true
                    
                }
                if (other is HasGameObject){
                    let has2 =  (other as! HasGameObject)
                    if ( has2.gameObject is Medium){
                        let medium = has2.gameObject as! Medium
                        if (contactMap[packet!] != nil){
                            
                            if (contactMap[packet!]!.mediumContacted.contains(medium)){
                                return true
                            }
                            
                            if (packet?.containsMedium(medium) == true){ //exit
                                if validateIncidence(packet!, medium, contact, exit: true){
                                    contactMap[packet!]!.mediumContacted.insert(medium)
                                    contactMap[packet!]!.exit.append((medium,contact))
                                                                    }
                            }else{
                                if validateIncidence(packet!, medium, contact, exit: false){
                                    contactMap[packet!]!.mediumContacted.insert(medium)
                                    contactMap[packet!]!.enter.append((medium,contact))
                                }
                            }
                        }else{
                            let temp2 = ContactContainer()
                            if (packet?.containsMedium(medium) == true){ //exit
                                if (validateIncidence(packet!, medium, contact, exit: true)){
                                    temp2.mediumContacted.insert(medium)
                                    temp2 .exit.append((medium,contact))
                                    
                                }
                            }else{
                                if (validateIncidence(packet!, medium, contact, exit: false)){
                                    temp2.mediumContacted.insert(medium)
                                    temp2.enter.append((medium,contact))
                                }
                                
                            }
                           // temp2.enter.append((other!,contact))
                            contactMap[packet!] = temp2
                            
                        }
                        return true
                    }
                }
            }
        }

        return false
    }
    
    
    
    func didEndContact(contact: SKPhysicsContact) {
   /*     ////print ("end A : \(contact.bodyA.node!.name) , B : \(contact.bodyB.node!.name) ")
        ////print(contact.contactNormal)
         ////print (contact.contactPoint)
        if  let temp  = contact.bodyA.node as? HasGameObject{
            if  let obj = (temp.gameObject) {
                if (contactMap[obj] != nil){
                    contactMap[obj]!.enter.append(contact)
                }else{
                    let temp2 = ContactContainer()
                    temp2.enter.append(contact)
                    contactMap[obj] = temp2
                    
                }
            }
        }*/
    }
    
    
    
    
    func handleContact(){
        
        for (packet, wrapper) in contactMap{
            
            
            if (wrapper.outOfArea == true){
                //do sth
                ////print("out of Area")
                /*
                if (packet.belongTo.count > 1){
                    var contact = packet.lastContactInfo
                    var conPos = packet.getBelongTo()!.getSprite()!.convertPoint(packet.lastPosition!, fromNode: gameLayer)
                    var temp: CGPoint = (packet.lastContactInfo?.contactPoint)! - gameLayer.position
                    
                    var conPos2 = packet.getBelongTo()!.getSprite()!.convertPoint(temp, fromNode: gameLayer)
                    
                    var conPos3 = packet.sprite.convertPoint((packet.lastContactInfo?.contactPoint)! - gameLayer.position, fromNode: gameLayer)
                    
                  //  print(CGPathContainsPoint(packet.getBelongTo()!.path, nil, temp, true))
                    
                    // //print(CGPathContainsPoint(medium.path, nil,temp , true))
                    var toward : CGVector = contact!.contactPoint - (packet.lastPosition! + gameLayer.position )
                    //print (toward.dot(packet.direction))
                //    print(toward.dot(contact!.contactNormal))
                      
                ////    print(contact!.contactNormal.dot(packet.lastDirection!))
                 //   print("wat")
                    
                }
*/
               
                packet.deleteSelf()
                continue
            }
            
            // case has enter
            /*
            if (wrapper.enter.count > 0){
                if (wrapper.exit.count == 0){ // only enter -> enter other medium
                    if (wrapper.enter.first != nil){
                        let medium = wrapper.enter.first!.0
                        packet.changeMedium(from: nil, to: medium, contact: wrapper.enter.first!.1)
                        
                    }
                }else{ //in and out , i.e. objects are close
                    let to = wrapper.enter.first!.0
                    let from = wrapper.exit.first!.0
                    packet.changeMedium(from: from, to: to, contact: wrapper.enter.first!.1)
                    
                }
            }else{
                if (wrapper.exit.count > 0){
                    if(wrapper.exit.first != nil){
                        let medium = wrapper.exit.first!.0
                        packet.changeMedium(from: medium, to: nil, contact: wrapper.exit.first!.1)
                    }
                }
            }
            
            */
            var froms = Set<Medium>()
            var tos = Set<Medium>()
            var contacts = [Medium : ContactInfo]()
            for (from , contact) in wrapper.exit {
                froms.insert(from)
                contacts[from] = contact
            }
            for (to, contact) in wrapper.enter{
                tos.insert(to)
                contacts[to] = contact
            }
            
            packet.changeMedium(from: froms, to: tos, contact: contacts)

        }
        contactMap.removeAll()
        //contactCount.removeAll()
        
        
    /*    for contact in contactQueue{
            if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil){
                continue
            }
            if  let temp  = contact.bodyA.node as? GameSKShapeNode {
                if  let obj = (temp.gameObject as? EnergyPacket) {
                    //obj.getSprite()?.removeFromParent()
                    //self.removeGameObjectFromList(self.attackPhaseObjects, obj: obj)
                    
                }
                
                
            }
            
        }
*/
    }
    
    
    func groupContact(){
        
        
    }
    
    func removeGameObjectFromList (var ls: [GameObject], obj obj :GameObject) ->(){
        for i in 0...(ls.count - 1){
            if (ls[i] === obj){
                ls.removeAtIndex(i)
                return
            }
        }
    }
    
    
    func addObjectsToNode (parent : SKNode, _ children : [GameObject])->(){
        for obj in children{
            if let temp = obj.getSprite(){
                parent.addChild(temp)
            }
        }
    }
    
    
    var touching : Bool = false
    var touchType : TouchType? = nil
    var prevTouchPoint : CGPoint? = nil
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if touches.count > 0 {//drag
            if let touch = touches.first  {
               touching  = true
                var touchDown =  touch.locationInNode(self)
               
                if (CGRectContainsPoint(playRect!, touchDown)){
                        touchType = TouchType.gameArea
                        prevTouchPoint = touchDown
                }
                
            }
        }
        
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (self.touchType == nil) { return }
        if (touches.count > 0 ) {//drag
            if let touch = touches.first {
                if (touchType! == TouchType.gameArea){
                    var newPt = touch.locationInNode(self)
                    var diff :CGVector =  prevTouchPoint! - newPt
                    prevTouchPoint  = newPt
                    var moveY = -diff.dy
                    scrollGameLayer(moveY)
              
                    
                }
            }
        }
    }
    
    func scrollGameLayer(movement : CGFloat){
        var newY = gameLayer.position.y + movement
        var diff = gameLayer.gameArea.height - playRect!.size.height
        var lowerBound = playRect!.origin.y - diff
        
        if newY < lowerBound{
            newY = lowerBound
        }else if newY > playRect!.origin.y {
            newY = playRect!.origin.y
        }
        //gameLayer.position.y = newY
        gameLayer.runAction(SKAction.moveToY(newY, duration: 0))
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touching = false
        touchType = nil
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        touching = false
        touchType = nil
    }
    
    
    
    
    
    var countFrame :Int = 0
    override func update(currentTime: CFTimeInterval) {
        
        switch (currentStage){
        case .Attack:
            
            handleContact()
            attackPhaseUpdate(currentTime)
           
            break
        default:
            break
        }
        //////print(currentTime - lastTimeStamp)
        if (countFrame % 30 == 0 && countFrame < 1000){
            switch (currentStage){
            case .Attack:
                
                for i in 0...10{
                    var tempx: CGFloat = (self.size.width - CGFloat(20)) / 10.0
                    tempx = tempx * CGFloat(i) + 10
                    var p1 = NormalEnergyPacket(2000, position: CGPoint(x: tempx + 1.5, y: 50))
                    p1.direction = CGVector(dx: 0, dy: 1)
                    p1.gameLayer = gameLayer
                    p1.pushBelongTo(gameLayer.background!)
                   gameLayer.addGameObject(p1)
                    p1 = NormalEnergyPacket(2000, position: CGPoint(x: tempx + 1.5, y: 50))
                    p1.direction = CGVector(dx: 0, dy: 1)
                    p1.gameLayer = gameLayer
                    p1.pushBelongTo(gameLayer.background!)
                    gameLayer.addGameObject(p1)
                }
                break
            default:
                break
            }

        }
        
      
        
        countFrame += 1
        if ((currentTime - lastTimeStamp) > 1  ){
            
            /* Called before each frame is rendered */
                        lastTimeStamp = currentTime
        }
       
    
        
    }

    
    
  
   
    
    func attackPhaseUpdate (currentTime: CFTimeInterval){
        gameLayer.update(currentTime)
    }
    
    
    func getMediumFromBodyB (contact : SKPhysicsContact) -> Medium? {
        if ( contact.bodyB.node?.parent == nil){
            return nil
        }
        return  ((contact.bodyB.node as! HasGameObject?)?.gameObject as! Medium?)
    }
    
    
    
}

/*
extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: file)
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData!)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! SKScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

extension SKScene{
    
    
    
    override class func unarchiveFromFile(file : String) -> SKNode? {
        if let sc : GameScene = super.unarchiveFromFile(file) as! GameScene{
            var p1 = NormalEnergyPacket(100,position: CGPoint(x: 300, y: 300))
            var p2 = NormalEnergyPacket(200,position: CGPoint(x: 300, y: 300))
            sc.attackPhaseObjects.append(p1)
            sc.attackPhaseObjects.append(p2)
            
            // addObjectsToNode(gameLayer, attackPhaseObjects )
            p1.getSprite()!.position = CGPoint(x: 10, y: 10)
            ////print(p1.getSprite())
            sc.gameLayer.addChild(p1.getSprite()!)
            sc.addChild(sc.gameLayer)
            return sc

        }
        return nil
    }
    
}
*/

class ContactContainer {
    var outOfArea : Bool = false
    var mediumContacted = Set<Medium>()
    var enter = [(Medium,ContactInfo)]()
    var exit = [(Medium,ContactInfo)]()
    
}

class ContactInfo {
    var contactPoint : CGPoint
    var contactNormal : CGVector
    
    init (_ cont:SKPhysicsContact){
        contactPoint = cont.contactPoint
        contactNormal = cont.contactNormal
    }

}




