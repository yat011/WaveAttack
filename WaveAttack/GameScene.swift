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
}

enum GameStage {
    case Superposition, Attack
}


class GameScene: SKScene , SKPhysicsContactDelegate{
    var attackPhaseObjects : [GameObject] = []
    var gameLayer  = SKNode()
    var infoLayer = SKNode()
    var controlLayer : SKShapeNode = SKShapeNode()
    var currentStage : GameStage = GameStage.Superposition
    
  
    override init(size: CGSize) {
       
        super.init(size: size)
        
        backgroundColor = SKColor.whiteColor()
      

       initGameLayer()
        initControlLayer()
        addObjectsToNode(gameLayer, attackPhaseObjects)
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
        var ph = self.size.height / 2
        gameLayer.position = CGPoint(x: 0, y : ph)
        
        // add boundary
        
     /*   let phys  = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height / 2)  )
        phys.categoryBitMask = CollisionLayer.GameBoundary.rawValue
        
        gameLayer.physicsBody = phys
*/
       // var p1 = NormalEnergyPacket(100, position: CGPoint(x: 0, y: 50))
       // attackPhaseObjects.append(p1)
        for i in 0 ... 10 {
            var tempx: CGFloat = (self.size.width - CGFloat(20)) / 10.0
            tempx = tempx * CGFloat(i) + 10
            var p1 = NormalEnergyPacket(100, position: CGPoint(x: tempx, y: 50))
             attackPhaseObjects.append(p1)
        

        }
      

        
    }
    
    func initControlLayer() -> (){
        controlLayer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height / 2) )
        controlLayer.fillColor = SKColor.blueColor()
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
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
        /* Called before each frame is rendered */
        switch (currentStage){
        case .Attack:
            attackPhaseUpdate(currentTime)
            break
        default:
            break
        }
        
    }
    
   
    
    func attackPhaseUpdate (currentTime: CFTimeInterval){
        for obj in attackPhaseObjects{
            obj.update()
        }
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
            print(p1.getSprite())
            sc.gameLayer.addChild(p1.getSprite()!)
            sc.addChild(sc.gameLayer)
            return sc

        }
        return nil
    }
    
}
*/
