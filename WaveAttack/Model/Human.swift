//
//  Human.swift
//  WaveAttack
//
//  Created by yat on 13/11/2015.
//
//

import Foundation
import SpriteKit
class Human  : SmallMovableObject, Spawnable{
    
    static let _oriTexture =  SKTexture(imageNamed: "human_full")
    static let _breakRect = [CGRect(x: 0, y: 0, width: 1, height: 0.4), CGRect(x: 0, y: 0.4, width: 1, height: 0.6)]
    override class var breakRect: [CGRect]? { get{return _breakRect}}
    override class var oriTexture : SKTexture? {get{return _oriTexture}}

    static var _breakTexture :[SKTexture]? = nil
    override class var breakTexture: [SKTexture]? {get {return _breakTexture} set(v){ _breakTexture = v}}
    override class var breakThreshold : [CGFloat]? {get{return [0.0]}}
    override var restitution : CGFloat {get{return 0.2}}
    override class var density :CGFloat? {get{return 1}}
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
        super.initialize(size, position: position, gameScene: gameScene)
        for each in sprites{
            each.name = "human"
        }
    }
   
   
    func spawnInit(position:CGPoint) {
       var newPt = CGPoint(x: position.x, y: gameLayer.ground!.frontY + 10)
        self.originHp = 10
       initialize(CGSize(width: 12, height: 19), position: newPt, gameScene: GameScene.current!)
        findTarget()
        self.sprite.zPosition = GameLayer.ZFRONT
    }
    override func jointBroken(node: SKSpriteNode) {
       let bloodBody = SKEmitterNode(fileNamed: "Blood.sks")
        let bloodHead = SKEmitterNode(fileNamed: "Blood.sks")
        bloodHead!.position.y =  -sprites[1].size.height/2
        bloodBody!.position.y =  sprites[0].size.height/2
        bloodHead!.zRotation = -MathHelper.PI
        bloodBody!.runAction(SKAction.sequence([SKAction.waitForDuration(5), SKAction.removeFromParent()]))
        bloodHead!.runAction(SKAction.sequence([SKAction.waitForDuration(5), SKAction.removeFromParent()]))
        sprites[0].addChild(bloodBody!)
        sprites[1].addChild(bloodHead!)
    }
    override func changeToFront(phys :SKPhysicsBody){
        isFront[phys.node!] = true
        phys.categoryBitMask = CollisionLayer.SmallObjects.rawValue
        phys.collisionBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue
        phys.contactTestBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue
    }
    override func createPhysicsBody(size: CGSize) -> SKPhysicsBody {
        var phys = super.createPhysicsBody(size)
        phys.categoryBitMask = CollisionLayer.SmallObjects.rawValue
        phys.collisionBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue 
        phys.contactTestBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue
        return phys
    }
    override func garbageCollected(){
        if self.dead == false{
            dead =  true
            triggerEvent(GameEvent.Dead.rawValue)
            gameLayer.removeGameObject(self)
        }
        
    }
 
}