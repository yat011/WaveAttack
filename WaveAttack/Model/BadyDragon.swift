

import Foundation
import SpriteKit

class BadyDragon: SmallMovableObject, Spawnable,Enemy{
    
    static let _oriTexture =  SKTexture(imageNamed: "Baby_Dragon")
    static let _breakRect = [CGRect(x: 0, y: 0, width: 0.9, height: 0.45), CGRect(x: 0, y: 0.45, width: 0.8, height: 0.55), CGRect(x: 0.9, y: 0, width: 0.1, height: 0.40)]
    override class var breakRect: [CGRect]? { get{return _breakRect}}
    override class var oriTexture : SKTexture? {get{return _oriTexture}}
    
    static var _breakTexture :[SKTexture]? = nil
    override class var breakTexture: [SKTexture]? {get {return _breakTexture} set(v){ _breakTexture = v}}
    override class var breakThreshold : [CGFloat]? {get{return [0.0, 0.65]}}
    override var restitution : CGFloat {get{return 0.2}}
    override class var density :CGFloat? {get{return 1}}
     override class var  damageFactor :CGFloat{ get {return 0.2}}
    override class var score :[CGFloat] { get {return [2000] }}
    override class var walkSpeed : CGFloat { get{return 100 }}
    override class var jumpSpeed: CGVector  {get { return CGVector(dx: 200, dy: 700)}}
    override class var jumpDetectAngle : CGFloat {get {return 1.3}}
   var angry = false
    var attacks =  [EnemyAction]()
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
        super.initialize(size, position: position, gameScene: gameScene)
        for each in sprites{
            each.name = "bady_dragon"
        }
       var  attack = TripleBulletAttack(enemy: self, cd: 8)
       attack.startAction()
        attacks.append(attack)
        
        
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
        if !angry && hp < originHp * 0.5  {
            angry = true
            for var i = 0 ; i < attachedIndex ; i++ {
                sprites[i].colorBlendFactor = 0.3
                sprites[i].runAction(SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0.5, duration: 1.5))
                actualWalkSpeed = 150
                var attack = TripleBulletAttack(enemy: self, cd: 14)
                attack.setRandomShoot()
                attack.startAction()
                attacks.append(attack)
                attack = TripleBulletAttack(enemy: self, cd: 14)
                attack.setRandomShoot()
                attack.startAction()
                attacks.append(attack)
 
                
            }
            
        }
        if walkTarget == nil{
            self.findTarget()
        }
    }
    
    func spawnInit(position:CGPoint) {
        self.originHp = 10000
        initialize(CGSize(width: 120, height: 100), position: position, gameScene: GameScene.current!)
        findTarget()
        self.sprite.zPosition = GameLayer.ZFRONT
    }
    override func jointBroken(node: SKSpriteNode) {
        if node === sprites[2]{
            let bloodbody = SKEmitterNode(fileNamed: "Blood.sks")
            let bloodtail = SKEmitterNode(fileNamed: "Blood.sks")
            bloodbody!.runAction(SKAction.sequence([SKAction.waitForDuration(5), SKAction.removeFromParent()]))
            bloodtail!.runAction(SKAction.sequence([SKAction.waitForDuration(5), SKAction.removeFromParent()]))
            bloodtail!.position.x = -sprites[2].size.width/2
            bloodtail!.zRotation = MathHelper.PI
            bloodbody!.zRotation = -MathHelper.PI
            bloodbody!.position.x = sprites[0].size.width/2
            bloodbody!.position.y -= sprites[0].size.height/2*0.5
           sprites[2].addChild(bloodtail!)
            
        }else{
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
    }
    
    
}