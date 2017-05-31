//
//  Meterorolite.swift
//  WaveAttack
//
//  Created by yat on 25/11/2015.
//
//

import Foundation
import SpriteKit
class Meterorolite :DestructibleObject, Spawnable, ContactListener{
    
   static let startVelocity = CGVector(dx: -400,dy: -400)
    var originPos :CGPoint? = nil
    static let _oriTexture =  SKTexture(imageNamed: "rock")
    static let _breakRect = [CGRect(x: 0, y: 0, width: 1, height: 1)]
    override class var breakRect: [CGRect]? { get{return _breakRect}}
    override class var oriTexture : SKTexture? {get{return _oriTexture}}
    static var _breakTexture :[SKTexture]? = nil
    override class var breakTexture: [SKTexture]? {get {return _breakTexture} set(v){ _breakTexture = v}}
    override class var score :[CGFloat] { get {return [200, 100] }}
    override class var breakThreshold : [CGFloat]? { get{return nil}}
    override class var  damageFactor :CGFloat{ get {return 0.2}}
    override class var density :CGFloat? {get{return 10}}
   let maxAmp = 60.f
    let maxLen = 600
    var fireNode: SKEmitterNode? = nil
    
    func spawnInit(position:CGPoint) {
        self.originHp = 100
        var newPt = CGPoint(x: position.x, y: 400)
        
        initialize(CGSize(width: 50, height: 50), position: newPt, gameScene: GameScene.current!)
        self.sprite.zPosition = GameLayer.ZFRONT
        sprites[0].physicsBody?.velocity = Meterorolite.startVelocity
        sprites[0].contactListener = self
        fireNode = SKEmitterNode(fileNamed: "Fire.sks")
        fireNode!.runAction(SKAction.sequence([SKAction.waitForDuration(10), SKAction.removeFromParent()]))
        sprites[0].addChild(fireNode!)
    }
    
    override func slowUpdate() {
        super.slowUpdate()
        
    }
   
    override func createPhysicsBody(size: CGSize) -> SKPhysicsBody {
        var phys =  SKPhysicsBody(circleOfRadius: size.width/2)
        phys.affectedByGravity = true
        phys.categoryBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.Custom.rawValue
        phys.collisionBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue | CollisionLayer.GameBoundary.rawValue
        phys.contactTestBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue
        phys.dynamic = true
        phys.angularDamping = 0.8
        phys.usesPreciseCollisionDetection = true
        phys.density = self.dynamicType.density!
        phys.restitution = self.restitution
        return phys
    }
    
    func contactWith(this: SKPhysicsBody, other: SKPhysicsBody) {
        if this.collisionBitMask & other.categoryBitMask > 0{
            changeToFront(this)
            gameLayer.ground?.startVibrate(createWaveDate(), globalStartPoint: (gameScene?.convertPoint(CGPoint(x: -300, y: 0), fromNode: self.sprites[0]))!)
            sprites[0].contactListener = nil
        }
    }
    func createWaveDate()-> [CGFloat]{
        var res = [CGFloat]()
        for var i = -300 ; i < 300; i++ {
            res.append(getAmp(i.f))
        }
        return res
        
    }
    func getAmp(x:CGFloat)->CGFloat{
        return -maxAmp * exp(-abs(x)/150) * cos(x/150*2 * MathHelper.PI)
        
    }
    
    
}