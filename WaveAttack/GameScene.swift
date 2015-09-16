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


class GameScene: SKScene , SKPhysicsContactDelegate{
   
    var gameLayer :GameLayer
    var infoLayer = SKNode()
    var controlLayer : SKShapeNode = SKShapeNode()
    var currentStage : GameStage = GameStage.Superposition
    var contactQueue = Array<SKPhysicsContact>()
    var endContactQueue  = [SKPhysicsContact]()
    var contactMap = [EnergyPacket : ContactContainer]()
    
    
   // let fixedFps : Double = 30
    var lastTimeStamp : CFTimeInterval = -100
   // var updateTimeInterval : Double
    override init(size: CGSize) {
       gameLayer = GameLayer(size: CGSize(width: size.width, height: size.height / 2))
        
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
        let ph = self.size.height / 2
        gameLayer.position = CGPoint(x: 0, y : ph)
        
        // add boundary
        
     /*   let phys  = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height / 2)  )
        phys.categoryBitMask = CollisionLayer.GameBoundary.rawValue
        
        gameLayer.physicsBody = phys
*/
       // var p1 = NormalEnergyPacket(100, position: CGPoint(x: 0, y: 50))
       // attackPhaseObjects.append(p1)
        for i in 0 ... 0 {
            var tempx: CGFloat = (self.size.width - CGFloat(20)) / 10.0
            tempx = tempx * CGFloat(i) + 10
            let p1 = NormalEnergyPacket(100, position: CGPoint(x: tempx, y: 50))
            p1.direction = CGVector(dx: 3, dy: 2)
            p1.gameLayer = gameLayer
            p1.pushBelongTo(gameLayer.background!)
           gameLayer.addGameObject(p1)

        }
      

        
    }
    
    func initControlLayer() -> (){
        controlLayer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height / 2) )
        controlLayer.fillColor = SKColor.blueColor()
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
     //   //print("contact")
        //print ("A : \(contact.bodyA.node!.name) #\(unsafeAddressOf(contact.bodyA.node!)) , B : \(contact.bodyB.node!.name) #\(unsafeAddressOf(contact.bodyB.node!))")
       // self.contactQueue.append(contact)
       //     //print (contact.contactPoint)
     ////print(contact.contactNormal)
        
    
      
        
        
        
        if ( tryFindEnergyPacket(contact.bodyA.node, other: contact.bodyB.node, contact: contact) == true){
            return
        }else if (tryFindEnergyPacket(contact.bodyB.node, other: contact.bodyA.node, contact: contact) == true){
            return
        }
        
        
        
    }
    
    func tryFindEnergyPacket(_ sk : SKNode?, other other : SKNode?, contact contact :SKPhysicsContact) -> Bool {
        var packet: EnergyPacket? = nil
        if (sk is HasGameObject){
            let has = sk as! HasGameObject?
            //print ("gameObject : \(has?.gameObject)")
            if ( has?.gameObject is EnergyPacket){
                packet = has!.gameObject as! EnergyPacket
                if (other!.name == GameObjectName.GameBoundary.rawValue){
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
                            if (packet?.containsMedium(medium) == true){ //exit
                               contactMap[packet!]!.exit.append((medium,contact))
                            }else{
                                contactMap[packet!]!.enter.append((medium,contact))
                            }
                        }else{
                            let temp2 = ContactContainer()
                            if (packet?.containsMedium(medium) == true){ //exit
                                temp2 .exit.append((medium,contact))
                            }else{
                                temp2.enter.append((medium,contact))
                                
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
   /*     //print ("end A : \(contact.bodyA.node!.name) , B : \(contact.bodyB.node!.name) ")
        //print(contact.contactNormal)
         //print (contact.contactPoint)
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
                //print("out of Area")
                gameLayer.removeGameObject(packet)
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
            var contacts = [Medium : SKPhysicsContact]()
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
    
    
    func addObjectsToNode (_ parent : SKNode, _ children : [GameObject])->(){
        for obj in children{
            if let temp = obj.getSprite(){
                parent.addChild(temp)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        switch (currentStage){
        case .Attack:
            
            handleContact()
            attackPhaseUpdate(currentTime)
            break
        default:
            break
        }
        ////print(currentTime - lastTimeStamp)
        //lastTimeStamp = currentTime

    /*
        if ((currentTime - lastTimeStamp) > updateTimeInterval ){
        
            /* Called before each frame is rendered */
            switch (currentStage){
            case .Attack:
                
                handleContact();
                attackPhaseUpdate(currentTime)
                break
            default:
                break
            }
            lastTimeStamp = currentTime
        }
        */
        
        
    }
    
   
    
    func attackPhaseUpdate (currentTime: CFTimeInterval){
        gameLayer.update(currentTime)
    }
    
    
    func getMediumFromBodyB (_ contact : SKPhysicsContact) -> Medium? {
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
            //print(p1.getSprite())
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
    var enter = [(Medium,SKPhysicsContact)]()
    var exit = [(Medium,SKPhysicsContact)]()
    
}

class ContactPair : Hashable, Equatable{
    var from : Medium?
    var to : Medium?
    init (_ from: Medium?, _ to: Medium?){
        
    }
    
    var hashValue: Int {
        var temp = 0
        if (from != nil){
            temp |= from!.hashValue
        }
        if (to != nil){
            temp |= to!.hashValue
        }
        return temp
    }

}


func ==(lhs: ContactPair, rhs: ContactPair) -> Bool {
    if (lhs.from === rhs.from && lhs.to === rhs.to){
        return true
    }
    return false
}

