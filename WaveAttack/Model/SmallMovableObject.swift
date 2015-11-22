//
//  SmallMovableObject.swift
//  WaveAttack
//
//  Created by yat on 18/11/2015.
//
//

import Foundation
import SpriteKit
class SmallMovableObject:SmallObject{
   
    var walkTarget : Enterable? = nil
    class var walkSpeed : CGFloat {get {return  20}}
    static let within : CGFloat = 20
    var _balance = true
    var isBalance :Bool {
        get{return _balance }
    }
    class var canJump : Bool {get {return true}}
    var jumpAvaliable = true
    var jumpTimer   :FrameTimer? = nil
    class var jumpSpeed: CGVector  {get { return CGVector(dx: 100, dy: 500)}}
    class var jumpDetectAngle : CGFloat {get {return 0.94720}}
    func findTarget(){
        var index = random()%gameLayer.enterables.count
        walkTarget = gameLayer.enterables[index]
    }
    func tryBalance(){
        if sprites[0].hasActions(){
            return
        }
        if isGrounded() && !checkObstacleAbove(){
            for var i = 0 ; i < attachedIndex ; i++ {
                sprites[i].physicsBody!.velocity =  sprites[i].physicsBody!.velocity + CGVector(dx: 0, dy: 200)
                //sprites[i].runAction(SKAction.)
                sprites[i].runAction(SKAction.rotateToAngle(0, duration: 0.5))
            }
        }
        
    }
    func checkWalkCondition() -> Bool{
     
        if (abs(sprites[0].zRotation) > MathHelper.PI/180*20 ){
            tryBalance()
            return false
        }
        
        guard  isGrounded() else{
            return false
        }
        return true
    }
    
    func checkObstacleAbove()-> Bool{
        return false
        /*
       var scenePt =  self.currentPos + gameLayer.position + CGPoint(x: -originSize!.width/2, y: -originSize!.height/2)
        
        
       var size = CGSize(width: originSize!.width/2, height: originSize!.height/2)
        var rect = CGRect(origin: scenePt, size: size)
       var res = false
        var allcontactedBodies = sprites[0].physicsBody!.allContactedBodies() as [AnyObject]
        
        for temp in allcontactedBodies{
                var each = unsafeBitCast(temp, SKPhysicsBody.self)
            
                print (each.node?.name)
        
        }
        gameScene!.physicsWorld.enumerateBodiesInRect(rect, usingBlock: {
            (body:SKPhysicsBody, stop : UnsafeMutablePointer<ObjCBool> ) -> () in
            if body.categoryBitMask & self.sprites[0].physicsBody!.collisionBitMask > 0 {
                print(body.node!.name)
                stop.memory = true
                res = true
            }
        })
        return res
*/
    }
    
    
   func checkAtAngle(angle:CGFloat)-> Bool{
    
        var dis  :CGFloat = 0
        var len :CGFloat = sqrt( pow(originSize!.width,2) + pow(originSize!.height, 2)) + 5
        let startPt = gameScene!.convertPoint(sprites[0].position, fromNode: sprite)
    
        var phys : SKPhysicsBody? = nil
        let endPt = startPt + CGPoint(x: len * CGFloat(cosf(Float(angle))) , y: len * CGFloat(sinf(Float(angle))))
         gameScene!.physicsWorld.enumerateBodiesAlongRayStart(startPt, end: endPt, usingBlock: {
            body,pt, normal, stop in
        
            
            if body.categoryBitMask &  self.sprites[0].physicsBody!.collisionBitMask > 0 {
                print (body.categoryBitMask)
                print(body.node!.name)
                phys = body
                stop.memory = true
                
            }
        })
        return (phys != nil)
       // guard phys != nil else { return false}
        //print(phys!.node!.name)
        //if sprites[0].physicsBody!.collisionBitMask & phys!.categoryBitMask  > 0{
         //   return true
        //}
        
    }
    func jump(direct :CGFloat){
        var jumpV = CGVector(dx: direct * self.dynamicType.jumpSpeed.dx, dy: self.dynamicType.jumpSpeed.dy)
        jumpAvaliable = false
        jumpTimer!.reset()
        jumpTimer!.startTimer({
           Void in
           self.jumpAvaliable = true
        })
        for var i  = 0 ; i < attachedIndex ; i++ {
            sprites[i].physicsBody!.velocity = jumpV
            sprites[i].runAction(SKAction.rotateToAngle(0, duration: 1))
        }
        
    }
 
    override func update() {
        super.update()
        // check if balance || grounded || die
        guard hp > 0 else{
            return
        }
       
        guard checkWalkCondition() == true else{return }
        
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
        if currentX > (walkTarget?.getPosition().x)! - SmallMovableObject.within && currentX < (walkTarget?.getPosition().x)! + SmallMovableObject.within {
            return true
        }
        if walkTarget!.getPosition().x > currentX{
            if checkIfObjectAtFront(1) == true{
                if (self.dynamicType.canJump && self.jumpAvaliable){
                    if (hp/self.originHp > 0.2 && !checkAtAngle(self.dynamicType.jumpDetectAngle)){
                       jump(1)
                        return false
                    }
                    
                }
                findTarget()
                return false
            }
            for each in sprites{
                each.physicsBody!.velocity = CGVector(dx: self.dynamicType.walkSpeed, dy: 0)
                each.zRotation = 0
            }
        }else{
            if checkIfObjectAtFront(-1) == true{
                if (self.dynamicType.canJump && jumpAvaliable){
                    if (hp/self.originHp > 0.2 && !checkAtAngle(-self.dynamicType.jumpDetectAngle + MathHelper.PI)){
                        jump(-1)
                        return false
                    }
                }
                findTarget()
                return false
            }
            for each in sprites{
               each.physicsBody!.velocity = CGVector(dx: -self.dynamicType.walkSpeed, dy: 0)
                each.zRotation = 0
                
            }
        }
        return false
    }
    override func afterAddToScene() {
        super.afterAddToScene()
        if self.dynamicType.canJump {
            jumpTimer  =  FrameTimer (duration: 2)
            gameScene!.generalUpdateList.insert(Weak(jumpTimer!))
        }
    }
    
}