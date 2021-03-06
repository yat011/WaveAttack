//
//  Building.swift
//  WaveAttack
//
//  Created by yat on 13/11/2015.
//
//

import Foundation
import SpriteKit
class Building: DestructibleObject{
    var originPos :CGPoint? = nil
    static let _oriTexture =  SKTexture(imageNamed: "building")
    static let _breakRect = [CGRect(x: 0, y: 0, width: 1, height: 0.6), CGRect(x: 0.3, y: 0.6, width: 0.7, height: 0.4), CGRect(x: 0, y: 0.6, width: 0.3, height: 0.4)]
    override class var breakRect: [CGRect]? { get{return _breakRect}}
    override class var oriTexture : SKTexture? {get{return _oriTexture}}
    static var _breakTexture :[SKTexture]? = nil
    override class var breakTexture: [SKTexture]? {get {return _breakTexture} set(v){ _breakTexture = v}}
    override class var score :[CGFloat] { get {return [200, 100] }}
    override class var breakThreshold : [CGFloat]? { get{return [0, 0.5]}}
    override class var  damageFactor :CGFloat{ get {return 0.2}}
    override class var density :CGFloat? {get{return 10}}
    var groundJoints = [SKPhysicsJoint]()
    var fireNode : SKSpriteNode?  = nil
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
        originPos = position
        super.initialize(size, position: position, gameScene: gameScene)
        originHp = 10000
    }
    
    override func fixedOnGround() {
        var ground = GameScene.current!.gameLayer!.ground!
        var base = sprites[0]
        
       
        var interval = base.frame.width/2
        for var i = 0 ; i < 3 ; i++ {
            var first = base.position + CGPoint(x: interval * CGFloat(i) - base.frame.width/2, y: 0)
            var selfGlobalA = GameScene.current!.convertPoint(first, fromNode: base.parent!)
             selfGlobalA = selfGlobalA - CGPoint(x: 0, y: 24)
            var firstX = ground.sprite.convertPoint(selfGlobalA, fromNode: base.scene!)
            var firstSprite =  ground.bottomFence[ground.mapLocalXToSpriteIndex(firstX.x)]
            
            var AGlobalPos = GameScene.current!.convertPoint(CGPoint(x:firstX.x,y:80), fromNode: ground.sprite)
            
            
            var jointA = SKPhysicsJointSpring.jointWithBodyA(firstSprite.physicsBody!, bodyB: base.physicsBody!, anchorA: AGlobalPos, anchorB: selfGlobalA)
            jointA.damping = 5
            jointA.frequency = 10
            groundJoints.append(jointA)
        }

        /*
        var first = base.position
        var selfGlobalA = GameScene.current!.convertPoint(first, fromNode: base.parent!)
        var firstX = ground.sprite.convertPoint(selfGlobalA, fromNode: base.scene!)
        var firstSprite =  ground.equilibrium[ ground.mapLocalXToSpriteIndex(firstX.x)]
        
        var AGlobalPos = GameScene.current!.convertPoint(CGPoint(x:firstX.x,y:80), fromNode: ground.sprite)
        
        
        var jointA = SKPhysicsJointFixed.jointWithBodyA(firstSprite.physicsBody!, bodyB: base.physicsBody!, anchor:  selfGlobalA)
*/
        //groundJoints.append(jointA)
        for j in groundJoints{
            GameScene.current!.physicsWorld.addJoint(j)
        }
        
        
    }
    override func slowUpdate() {
        super.slowUpdate()
        
        if abs(sprites[0].zRotation) > MathHelper.PI/180 * 30 {
            for j in groundJoints{
                GameScene.current!.physicsWorld.removeJoint(j)
            }
            groundJoints.removeAll()
            for each in sprites{
                changeToFront(each.physicsBody!)
            }
        }
        
    }
    override func jointBroken(node: SKSpriteNode) {
        if breakIndex != -1 {
           return
        }
       let smoke =   SKEmitterNode(fileNamed: "Smoke.sks")
        let fire = SKEmitterNode(fileNamed: "Fire.sks")
        fireNode=SKSpriteNode()
        fireNode!.addChild(smoke!)
        fireNode!.addChild(fire!)
        fireNode!.zPosition = GameLayer.ZFRONT + 1
        fire!.zPosition = 1
        var actions = [ SKAction.waitForDuration(10),SKAction.fadeAlphaTo(0, duration: 2), SKAction.removeFromParent()]
        sprites[0].colorBlendFactor = 0.2
        sprites[0].color = SKColor.blackColor()
        
        smoke?.runAction(SKAction.sequence(actions))
        fire?.runAction(SKAction.sequence(actions))
       sprite.addChild(fireNode!)
        
    }
    override func syncPos() {
        super.syncPos()
        guard fireNode != nil else{return}
        fireNode!.position = sprites[0].position
    }
    
    override func afterAddToScene() {
        super.afterAddToScene()
        sprite.position = CGPoint(x: sprite.position.x, y: gameLayer.ground!.backY + originSize!.height/2 + 1)
    }
   
    
    
}