//
//  Human.swift
//  WaveAttack
//
//  Created by yat on 13/11/2015.
//
//

import Foundation
import SpriteKit
class Human  : SmallObject, Spawnable{
    
    static var _textures = [SKTexture(imageNamed: "human_up"),SKTexture(imageNamed: "human_down")]
    static let _oriTexture =  SKTexture(imageNamed: "human_full")
    static let _breakRect = [CGRect(x: 0, y: 0, width: 1, height: 0.4), CGRect(x: 0, y: 0.4, width: 1, height: 0.6)]
    override class var breakRect: [CGRect]? { get{return _breakRect}}
    override class var oriTexture : SKTexture? {get{return _oriTexture}}

    static var _breakTexture :[SKTexture]? = nil
    override class var breakTexture: [SKTexture]? {get {return _breakTexture} set(v){ _breakTexture = v}}
    override class var textures:[SKTexture]? {get{
       return _textures
        
        }
    }
    override class var breakThreshold : [CGFloat]? {get{return [0.0]}}
    override var restitution : CGFloat {get{return 0.2}}
    override class var density :CGFloat? {get{return 1}}
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
        super.initialize(size, position: position, gameScene: gameScene)
        for each in sprites{
            each.name = "human"
        }
    }
    var walkTarget : Enterable? = nil
    var walkSpeed : CGFloat = 2
    var _balance = true
    var isBalance :Bool {
        get{return _balance }
    }
 
    func findTarget(){
       var index = random()%gameLayer.enterables.count
       walkTarget = gameLayer.enterables[index]
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
        sprites[0].addChild(bloodBody!)
        sprites[1].addChild(bloodHead!)
    }
    override func update() {
        super.update()
        // check if balance || grounded || die
        guard hp > 0 else{
            return
        }
        guard isBalance else{
            return
        }
        if (abs(sprites[0].zRotation) > MathHelper.PI/180*20 ){
           _balance = false
            return 
        }
        
        guard  isGrounded() else{
            return
        }
        
        guard walkTarget != nil else {return }
        if walk() == true{
           walkTarget?.enter(self)
            walkTarget = nil
        }
      //  print(sprites[0].zRotation)
       // if (abs(sprites[0].zRotation) > MathHelper.PI/180*30 && unionNode.hasActions() == false){
            
            //unionNode.physicsBody!.ap
            //unionNode.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 2))
       // }
    }
    func walk () -> Bool{
        let currentX = sprite.position.x + sprites[0].position.x
        if currentX > (walkTarget?.getPosition().x)! + walkSpeed && currentX < (walkTarget?.getPosition().x)! + walkSpeed{
           return true
        }
        if walkTarget!.getPosition().x > currentX{
            if checkIfObjectAtFront(1) == true{
                findTarget()
               return false
            }
            for each in sprites{
                each.runAction(SKAction.moveByX(walkSpeed, y: 0, duration: 0))
                each.zRotation = 0
            }
        }else{
            if checkIfObjectAtFront(-1) == true{
                findTarget()
                return false
            }
            for each in sprites{
                each.runAction(SKAction.moveByX(-walkSpeed, y: 0, duration: 0))
                each.zRotation = 0
            }
        }
        return false
    }
    
}