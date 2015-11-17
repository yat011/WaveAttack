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
    var walkSpeed : CGFloat = 2
    var _balance = true
    var isBalance :Bool {
        get{return _balance }
    }
    
    func findTarget(){
        var index = random()%gameLayer.enterables.count
        walkTarget = gameLayer.enterables[index]
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
        if currentX > (walkTarget?.getPosition().x)! - walkSpeed && currentX < (walkTarget?.getPosition().x)! + walkSpeed{
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