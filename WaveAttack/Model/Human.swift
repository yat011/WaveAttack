//
//  Human.swift
//  WaveAttack
//
//  Created by yat on 13/11/2015.
//
//

import Foundation
import SpriteKit
class Human  : DestructibleObject{
    
     var _textures = [SKTexture(imageNamed: "human_up"),SKTexture(imageNamed: "human_down")]
    override var textures:[SKTexture]? {get{
       return _textures
        
        }
    }
    override var breakThreshold : [CGFloat]? {get{return [0.8]}}
    override var restitution : CGFloat {get{return 0.5}}
    override var density :CGFloat? {get{return 1}}
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
        super.initialize(size, position: position, gameScene: gameScene)
        for each in sprites{
            each.name = "human"
        }
       changeToFront(unionNode.physicsBody!)
    }
    

   /*
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
        var testSize = CGSize(width: 30, height: 40)
        self.originPoint = position
        self.originSize = testSize
      
        for texture in textures!{
            
            var sprite = GameSKSpriteNode(texture: texture)
            sprite.gameObject = self
            sprite.size = testSize
            sprite.physicsBody = createPhysicsBody(texture, size: testSize)
            self.sprite.addChild( sprite)
            self.sprites.append(sprite)
            
        }
        
        //  phys.usesPreciseCollisionDetection = true
        hpBarRect = CGRect(origin: position, size: CGSize(width: 20, height: 10))
        sprite.position = position
        
    }
    */
    override func createPhysicsBody(texture: SKTexture ,size: CGSize) -> SKPhysicsBody {
        var phys = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width/2, height: size.height/2))
        phys.categoryBitMask = CollisionLayer.FrontObjects.rawValue
        phys.affectedByGravity = true
        phys.collisionBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue  | CollisionLayer.GameBoundary.rawValue
        phys.contactTestBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue  | CollisionLayer.GameBoundary.rawValue
        phys.dynamic = true
        phys.usesPreciseCollisionDetection = true
        return phys
    }
    override func createNoCollisionPhysicsBody(texture: SKTexture, size: CGSize) -> SKPhysicsBody {
        var phys = SKPhysicsBody(rectangleOfSize: CGSize(width: size.width/2, height: size.height/2))
        phys.categoryBitMask = 0
        phys.affectedByGravity = true
        phys.collisionBitMask = 0
        phys.contactTestBitMask = 0
        phys.dynamic = true
        phys.usesPreciseCollisionDetection = true
        return phys

    }
    override func changeToFront(phys: SKPhysicsBody) {
        
        print("change to front")
        return  super.changeToFront(phys)
    }
    
    /*
    override func afterAddToScene() {
       
        var headBody = createPhysicsJointFixed(sprites[0], bodyB: sprites[1], anchor: CGPoint(x: 0, y: 100))
        
        joints.append(headBody)
        var bodyHands = createPhysicsJointFixed(sprites[2], bodyB: sprites[1], anchor: CGPoint(x: 0, y: 0.10))
        var bodyLegs = createPhysicsJointFixed(sprites[3], bodyB: sprites[1], anchor: CGPoint(x: 0, y: -0.15))

        joints.append(bodyHands)
        joints.append(bodyLegs)

    
        for joint in joints{
            GameScene.current!.physicsWorld.addJoint(joint)
        }
        
    }
*/
   
    
    override func update() {
        super.update()
      //  print(sprites[0].zRotation)
        if (abs(sprites[0].zRotation) > MathHelper.PI/180*30 && unionNode.hasActions() == false){
            
            //unionNode.physicsBody!.ap
            //unionNode.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 2))
        }
    }
    
}