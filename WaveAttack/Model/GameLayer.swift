//
//  GameLayer.swift
//  WaveAttack
//
//  Created by yat on 13/9/2015.
//
//

import Foundation
import SpriteKit


class GameLayer : SKNode{
    
   let  boundary : [SKShapeNode] = []
    var background : Medium? = nil
    var attackPhaseObjects = Set<GameObject>()
    var gameArea = CGRect()
    var size : CGSize
    init(size : CGSize, gameScene : GameScene) {
        self.size = size
       
        super.init()
         gameArea = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: size.width, height: 2 * size.height))//temp
        background = Soil(size: gameArea.size, position: CGPoint(x: 0,y: 0), gameScene: gameScene)
        print(background!.getSprite()!)
        self.addChild(background!.getSprite()!)
        print ("upper screen size \(gameArea))")
       // gameArea = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: size.width, height: 2 * size.height))//temp
        
      
        /*
        //upper
        var temp = SKShapeNode(rect: CGRect(x: -1 * (size.width + 100) / 2, y: 0, width: size.width - 100, height: 100))
        temp.name = GameObjectName.GameBoundary.rawValue
        temp.fillColor = SKColor.blueColor()
        temp.position = CGPoint(x: (size.width + 100 ) / 2 , y: size.height + 60)
        temp.physicsBody = createPhysicsBodyBoundary(temp)
         self.addChild(temp)
        //right
        temp = SKShapeNode(rect: CGRect(x:  0, y: 0, width: 100, height: size.height + 100))
        temp.name = GameObjectName.GameBoundary.rawValue
        temp.fillColor = SKColor.blueColor()
        temp.position = CGPoint(x: size.width + 10 , y: -50)
        temp.physicsBody = createPhysicsBodyBoundary(temp)
        self.addChild(temp)
        //bottom
        temp = SKShapeNode(rect: CGRect(x:  0, y: 0, width: size.width + 100, height: 100))
        temp.name = GameObjectName.GameBoundary.rawValue
        temp.fillColor = SKColor.blueColor()
        temp.position = CGPoint(x: -10 , y: -10 - 100)
        temp.physicsBody = createPhysicsBodyBoundary(temp)
        self.addChild(temp)
        
        //left
        temp = SKShapeNode(rect: CGRect(x:  0, y: 0, width: 100, height: size.height + 100))
        temp.name = GameObjectName.GameBoundary.rawValue
        temp.fillColor = SKColor.blueColor()
        temp.position = CGPoint(x: -10 - 100 , y: -50)
        temp.physicsBody = createPhysicsBodyBoundary(temp)
        self.addChild(temp)
        */

        
       
        
        
        //test box
        var box = SampleBox(size: CGSize(width: 200,height: 100), position: CGPoint(x: 150, y: 160), gameScene: gameScene)
        
       // box.getSprite()!.zPosition = -1
        //box.getSprite()!.runAction(SKAction.rotateByAngle(-1, duration: 0))
        addGameObject(box)
        box = SampleBox(size: CGSize(width: 200,height: 80), position: CGPoint(x: 250, y: 500), gameScene: gameScene)
        box.propagationSpeed = 3
        box.zIndex = 1
        box.getSprite()!.runAction(SKAction.rotateByAngle(-1, duration: 0))
        // box.getSprite()!.zPosition = -1
        addGameObject(box)

        
    }

    private func createPhysicsBodyBoundary ( node : SKShapeNode ) -> SKPhysicsBody{
    
        let phys = SKPhysicsBody(edgeChainFromPath: node.path!)
       
        
        //print (node.frame.size)
       // phys.affectedByGravity = false
        phys.categoryBitMask = CollisionLayer.GameBoundary.rawValue
        phys.collisionBitMask = 0x0
        return phys
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGameObject(_ obj : GameObject){
        attackPhaseObjects.insert(obj)
        if (obj.getSprite() != nil){
            self.addChild(obj.getSprite()!)
        }
    }
    
    func removeGameObject (_ obj : GameObject){
        attackPhaseObjects.remove(obj)
        if (obj.getSprite() != nil){
            obj.getSprite()!.removeFromParent()
        }
    }
    
    func update(currentTime: CFTimeInterval){
        for obj in  attackPhaseObjects{
            obj.update()
        }
    }
   
}


