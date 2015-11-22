//
//  EyeBallMan.swift
//  WaveAttack
//
//  Created by yat on 18/11/2015.
//
//

import Foundation
import SpriteKit

class EyeBallMan: SmallMovableObject, Spawnable,Enemy{
    
    static let _oriTexture =  SKTexture(imageNamed: "strangeEybal")
    static let _breakRect = [CGRect(x: 0, y: 0, width: 1, height: 0.4), CGRect(x: 0, y: 0.4, width: 1, height: 0.6)]
    override class var breakRect: [CGRect]? { get{return _breakRect}}
    override class var oriTexture : SKTexture? {get{return _oriTexture}}
    
    static var _breakTexture :[SKTexture]? = nil
    override class var breakTexture: [SKTexture]? {get {return _breakTexture} set(v){ _breakTexture = v}}
    override class var breakThreshold : [CGFloat]? {get{return [0.0]}}
    override var restitution : CGFloat {get{return 0.2}}
    override class var density :CGFloat? {get{return 1}}
     override class var  damageFactor :CGFloat{ get {return 0.2}}
    override class var score :[CGFloat] { get {return [300] }}
    override class var walkSpeed : CGFloat { get{return 40 }}
    
    var attack : EnemyAction? = nil
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
        super.initialize(size, position: position, gameScene: gameScene)
        for each in sprites{
            each.name = "eyeBall"
        }
        attack = DirectAttack(enemy: self, cd: 10)
        attack!.startAction()
    
    }
   
    override func findTarget() {
       
        var positionX = CGFloat(random()%Int(gameScene!.gameArea!.width))
        var target = TargetPoint()
        target.pos.x = positionX
        target.pos.y = gameLayer.ground!.frontY
        self.walkTarget = target
    }
    override func update() {
        super.update()
        if walkTarget == nil{
            self.findTarget()
        }
    }
    
    func spawnInit(position:CGPoint) {
        self.originHp = 100
        initialize(CGSize(width: 30, height: 39), position: position, gameScene: GameScene.current!)
        findTarget()
        self.sprite.zPosition = GameLayer.ZFRONT
    }
    override func jointBroken(node: SKSpriteNode) {
        let bloodBody = SKEmitterNode(fileNamed: "Blood.sks")
        let bloodHead = SKEmitterNode(fileNamed: "Blood.sks")
        bloodBody!.particleColorSequence = nil
        bloodBody!.particleColor = SKColor.greenColor()
        bloodHead!.particleColorSequence = nil
        bloodHead!.particleColor = SKColor.greenColor()
        bloodHead!.position.y =  -sprites[1].size.height/2
        bloodBody!.position.y =  sprites[0].size.height/2
        bloodHead!.zRotation = -MathHelper.PI
        bloodBody!.runAction(SKAction.sequence([SKAction.waitForDuration(5), SKAction.removeFromParent()]))
        bloodHead!.runAction(SKAction.sequence([SKAction.waitForDuration(5), SKAction.removeFromParent()]))
        sprites[0].addChild(bloodBody!)
        sprites[1].addChild(bloodHead!)
    }
  
    
}