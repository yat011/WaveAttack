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
    var size : CGSize
    init(size : CGSize) {
        self.size = size
       
        super.init()
        
        //upper
        let temp = SKShapeNode(rect: CGRect(x: -1 * (size.width + 100) / 2, y: 0, width: size.width - 100, height: 100))
        temp.name = GameObjectName.GameBoundary.rawValue
        temp.fillColor = SKColor.blueColor()
        temp.position = CGPoint(x: (size.width + 100 ) / 2 , y: size.height + 60)
        temp.physicsBody = createPhysicsBodyBoundary(temp)
        
        
        
         background = Soil(size: self.size)
        self.addChild(background!.getSprite()!)
        self.addChild(temp)
        
        
        //test box
        var box = SampleBox(size: CGSize(width: 200,height: 100), position: CGPoint(x: 0, y: 160))
        box.propagationSpeed = 50
       // box.getSprite()!.zPosition = -1
        //box.getSprite()!.runAction(SKAction.rotateByAngle(-1, duration: 0))
        addGameObject(box)
        box = SampleBox(size: CGSize(width: 200,height: 80), position: CGPoint(x: 250, y: 260))
        box.propagationSpeed = 50
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