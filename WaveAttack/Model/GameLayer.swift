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
   // var gameArea = CGRect()
    weak var subMission: SubMission? = nil
    var totalTarget: Int = 0
    
    weak var gameScene: GameScene? = nil
    init(subMission : SubMission, gameScene : GameScene) {
        
       self.subMission = subMission
        self.gameScene = gameScene
        super.init()
         //gameArea = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: size.width, height: 2 * size.height))//temp
        background = subMission.terrain
       // print(background!.getSprite()!)
        self.addChild(background!.getSprite()!)
       // print ("upper screen size \(gameArea))")
       // gameArea = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: size.width, height: 2 * size.height))//temp
        
   
        for medium in subMission.objects{
            if (medium is DestructibleObject){
                var des = medium as! DestructibleObject
                if des.target {
                    totalTarget += 1
                }
            }
            
            addGameObject(medium)
        }


       
        
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
        if (obj is DestructibleObject){
            var des = obj as! DestructibleObject
            if des.target{
                totalTarget -= 1
                if totalTarget == 0{
                    
                    print ("clear one submissoin")
                    self.gameScene!.completeSubMission()
                }
            }
        }
        
    }
    
    func update(currentTime: CFTimeInterval){
        for obj in  attackPhaseObjects{
            obj.update()
        }
    }
    
    
    func deleteSelf(){
        for  gameObj in attackPhaseObjects{
            gameObj.deleteSelf()
        }
        attackPhaseObjects.removeAll()
        
    }
   
}


