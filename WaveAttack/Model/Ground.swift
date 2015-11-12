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
    var equilibrium = [SKSpriteNode]()
    var interval : CGFloat =  1
    var texture = SKTexture(imageNamed: "ground")
    var oriSize : CGSize? = nil
    
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
            phys!.dynamic = true
            tempSprite.physicsBody = phys
             tempSprite.position = tempPos

           /*
            
            //---- equil
            var equilSprite = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 10, height: 10))
        
            equilSprite.zPosition = 10000
            var equilPhys = SKPhysicsBody(circleOfRadius: 1)
            equilPhys.affectedByGravity = false
            equilPhys.dynamic = true
            equilPhys.collisionBitMask = 0
            equilPhys.contactTestBitMask = 0
            equilSprite.physicsBody = equilPhys
            equilSprite.position = tempPos
           */
             tempSprite.position = tempPos
            //equilibrium.append(equilSprite)
        
            sprites.append(tempSprite)
            sprite.addChild(tempSprite)
            //sprite.addChild(equilSprite)
            
        
        }
        sprite.position = position
        
    }
    override func afterAddToScene() {
        
        /*for var i = 0 ; i < sprites.count ; i++ {
            var equil = equilibrium[i]
            var eqPt = GameScene.current!.convertPoint(equil.position, fromNode: sprite)
           var joint =  SKPhysicsJointSpring.jointWithBodyA(sprites[i].physicsBody!, bodyB: equilibrium[i].physicsBody!, anchorA: eqPt, anchorB: eqPt)
            print(equil.physicsBody!)
            joint.frequency = 1.0
            GameScene.current!.physicsWorld.addJoint(joint)
            sprites[i].physicsBody!.applyImpulse(CGVector(dx: 0, dy: 10))
        }
*/
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
    
    func startVibrate(data:[CGFloat], globalStartPoint : CGPoint , completion : (()->())){
        var localPt = sprite.convertPoint(globalStartPoint, fromNode: GameScene.current!)
       var player = GameScene.current!.player!
        print(data.count)
        var i = 0
        for each in sprites{
            var index = mapLocalXToDataIndex(each.position.x, startX: localPt.x, count: data.count)
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
    
    func mapLocalXToSpriteIndex (x:CGFloat) -> Int{
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
