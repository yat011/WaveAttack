//
//  Ground.swift
//  WaveAttack
//
//  Created by yat on 11/11/2015.
//
//

import Foundation
import SpriteKit

class Ground: Medium{
    var sprite  = SKSpriteNode()
    var sprites = [GameSKSpriteNode]()
    var frontSprites = [GameSKSpriteNode]()
    var equilibrium = [SKSpriteNode]()
    var interval : CGFloat =  3
    var texture = SKTexture(imageNamed: "ground")
    var oriSize : CGSize? = nil
    var joints = [SKPhysicsJointSpring]()
    override func getSprite() -> SKNode? {
        return sprite
    }
    
    
    
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
       // var textures = [SKTexture]()
        oriSize = size
        var numInterval  = Int(Float(size.width / interval))
        for var i=0 ; i < numInterval ; i++ {
            var rect = CGRect(x: (CGFloat(i) * self.interval)/size.width, y: 0, width: 1 / CGFloat(numInterval), height: 1)
            var tempTexture = (SKTexture(rect: rect, inTexture: texture))
           
            var tempSprite = GameSKSpriteNode(texture: tempTexture)
            var tempSize = CGSize(width: size.width / CGFloat(numInterval), height: size.height)
            var tempX :CGFloat =  -size.width/2  + tempSize.width/2 + CGFloat(i) * tempSize.width
            var tempPos = CGPoint(x: tempX, y: 0)
           
            tempSprite.gameObject = self
            tempSprite.size = tempSize
            var phys:SKPhysicsBody? = nil
          
            
            //phys = SKPhysicsBody(texture: tempSprite.texture!, size: tempSize)
            phys = SKPhysicsBody(rectangleOfSize: tempSize)
            phys!.categoryBitMask = CollisionLayer.Ground.rawValue
            phys!.affectedByGravity = false
            phys!.collisionBitMask = 0
            phys!.contactTestBitMask = 0
            phys!.density = 100
            phys!.allowsRotation = false
            //phys!.linearDamping = 08
            phys!.usesPreciseCollisionDetection = true
            phys!.dynamic = true
            tempSprite.physicsBody = phys
             tempSprite.position = tempPos
            // front
            var frontSprite = GameSKSpriteNode()
            frontSprite.gameObject = self
            var frontPhys = SKPhysicsBody(rectangleOfSize: tempSize)
            frontPhys.categoryBitMask = CollisionLayer.FrontGround.rawValue
            frontPhys.affectedByGravity = false
            frontPhys.collisionBitMask =   0
            frontPhys.contactTestBitMask = 0
            frontPhys.density = 100
            frontPhys.allowsRotation = false
            frontPhys.usesPreciseCollisionDetection = true
            //frontPhys.linearDamping = 0
            frontPhys.dynamic = true
            //frontPhys.mass = 0
            frontSprite.physicsBody = frontPhys
            frontSprite.position = tempPos - CGPoint(x: 0, y: 20)
        
           
            
            //---- equil
            var equilSprite = SKSpriteNode()
        
            equilSprite.zPosition = 10000
            var equilPhys = SKPhysicsBody(circleOfRadius: 1)
            equilPhys.affectedByGravity = false
            equilPhys.dynamic = false
            equilPhys.categoryBitMask = 0
            equilPhys.collisionBitMask = 0
            equilPhys.contactTestBitMask = 0
            equilSprite.physicsBody = equilPhys
            equilSprite.position = tempPos
           
             tempSprite.position = tempPos
            equilibrium.append(equilSprite)
        
            frontSprites.append(frontSprite)
            sprites.append(tempSprite)
            sprite.addChild(tempSprite)
            sprite.addChild(equilSprite)
            sprite.addChild(frontSprite)
            
        
        }
        sprite.position = position
        
    }
    override func afterAddToScene() {
        
        for var i = 0 ; i < sprites.count ; i++ {
            var equil = equilibrium[i]
            var eqPt = GameScene.current!.convertPoint(equil.position, fromNode: sprite)
           var joint =  SKPhysicsJointSpring.jointWithBodyA(sprites[i].physicsBody!, bodyB: equilibrium[i].physicsBody!, anchorA: eqPt, anchorB: eqPt)
            var fixJoint =  SKPhysicsJointFixed.jointWithBodyA(sprites[i].physicsBody!, bodyB: frontSprites[i].physicsBody!, anchor: eqPt)
          //  print(equil.physicsBody!)
            //joint.
            joint.damping = 0.3
            joint.frequency = 1.0
           var frontjoint =  SKPhysicsJointSpring.jointWithBodyA(frontSprites[i].physicsBody!, bodyB: equilibrium[i].physicsBody!, anchorA: eqPt, anchorB: eqPt)
            frontjoint.damping = 0.3
            frontjoint.frequency = 1.0
            joints.append(joint)
            GameScene.current!.physicsWorld.addJoint(joint)
            GameScene.current!.physicsWorld.addJoint(frontjoint)
            //sprites[i].physicsBody!.applyImpulse(CGVector(dx: 0, dy: 0.5))
        }

       /*
        var test = [CGFloat]()
        for _ in 0..<300{
            test.append(20)
        }
        startVibrate(test, globalStartPoint: CGPoint(x: 37.5 , y: 0), completion: {
            () -> () in
            print("completeion")
        })
*/
    }
    var vibrateCompletion : (()->())? = nil
    
    func startVibrate(data:[CGFloat], globalStartPoint : CGPoint , completion : (()->())){
        var localPt = sprite.convertPoint(globalStartPoint, fromNode: GameScene.current!)
       var player = GameScene.current!.player!
        print(data.count)
        vibrateCompletion = completion
        var i = 0
        for each in sprites{
            
            var index = mapLocalXToDataIndex(each.position.x, startX: localPt.x, count: data.count)
            
            each.physicsBody!.applyImpulse(CGVector(dx: 0, dy: data[index]*10))
            
            frontSprites[i].physicsBody!.applyImpulse(CGVector(dx: 0, dy: data[index]*10))
            /*
            var actions = [SKAction]();
            actions.append( SKAction.moveToY(data[index], duration: Double(player.peroid/4) ))
            actions[0].timingMode = .EaseOut
            actions.append(SKAction.moveToY(0,duration: Double(player.peroid/4)))
            actions[1].timingMode = .EaseIn
            actions.append( SKAction.moveToY(-data[index], duration: Double(player.peroid/4) ))
            actions[2].timingMode = .EaseOut
            actions.append(SKAction.moveToY(0,duration: Double(player.peroid/4)))
            actions[3].timingMode = .EaseIn
            // actions[]
            // SKPhysicsJointSpring.j
            for var k in 1..<player.numOfOscillation{
                actions.appendContentsOf(actions)
            }
            
            if i==0 {
                each.runAction(SKAction.sequence(actions), completion: completion)
            }else{
                each.runAction(SKAction.sequence(actions))
            }
*/
            i++
        }
        
      /*
        for var i=0 ; i < data.count ; i++ {
            var index = mapLocalXToSpriteIndex(localPt.x + CGFloat(i))
            print(index)
            if sprites[index].hasActions() {
                continue
            }
            var actions = [SKAction]();
            actions.append( SKAction.moveToY(data[i], duration: Double(player.peroid/4) ))
            actions[0].timingMode = .EaseOut
            actions.append(SKAction.moveToY(0,duration: Double(player.peroid/4)))
            actions[1].timingMode = .EaseIn
            actions.append( SKAction.moveToY(-data[i], duration: Double(player.peroid/4) ))
            actions[2].timingMode = .EaseOut
            actions.append(SKAction.moveToY(0,duration: Double(player.peroid/4)))
            actions[3].timingMode = .EaseIn
           // actions[]
           // SKPhysicsJointSpring.j
            for var k in 1..<player.numOfOscillation{
                actions.appendContentsOf(actions)
            }
            
            if i==0 {
                sprites[index].runAction(SKAction.sequence(actions), completion: completion)
            }else{
                sprites[index].runAction(SKAction.sequence(actions))
            }
        }
        */
        
        
    }
    override func update() {
        var i = 0;
        for each in sprites{
            each.physicsBody!.velocity = CGVector(dx: 0, dy: each.physicsBody!.velocity.dy)
            frontSprites[i].physicsBody!.velocity = CGVector(dx: 0, dy: each.physicsBody!.velocity.dy)
            frontSprites[i].runAction(SKAction.rotateToAngle(0, duration: 0))
            each.runAction(SKAction.rotateToAngle(0, duration: 0))
           // if each.physicsBody!.velocity.dy < 0.1 && abs(each.position.y) < 5{
               // each.position = CGPoint(x: each.position.x, y:0)
            // each.physicsBody!.velocity = CGVector()
           // }
            i++
        }
        
        
        if vibrateCompletion != nil{
            for each in sprites{
                if each.physicsBody!.velocity.dy > 0.1 {
                    return
                }
                
            }
            
            vibrateCompletion!()
            vibrateCompletion = nil
        }
        
    }
    
    func mapLocalXToSpriteIndex (x:CGFloat) -> Int{
        print(x)
        return Int((x + oriSize!.width/2)/interval)
    }
    
    func mapLocalXToDataIndex( localX:CGFloat, startX: CGFloat, count: Int)->Int{
        var dx = Int(localX - startX  )
        if (dx < 0){
            print(dx%count)
            return  dx%count + count
        }else{
            return dx%count
        }
    }
    
}
