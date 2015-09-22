//
//  DestructibleObject.swift
//  WaveAttack
//
//  Created by yat on 14/9/2015.
//
//

import Foundation
import SpriteKit
class DestructibleObject : Medium {
    
    var hp : CGFloat = 1000
    var absorptionRate :CGFloat = 0.01
    var damageReduction :CGFloat = 0
    var scaleX: CGFloat  = 1
    var scaleY : CGFloat = 1
    var totDmg: CGFloat = 0
    var disappearThreshold: CGFloat = -100
    var target : Bool = false
    
    var scaled : Bool = false
    var prevScale : CGFloat = 1
    func calculateDamage(packet : EnergyPacket){
        var damage: CGFloat = packet.energy * absorptionRate
        packet.energy = packet.energy - damage
        damage = damage - damageReduction
        if (damage < 0){
            damage = 0
        }
        hp = hp - damage
        totDmg = totDmg + damage
        if (hp < 0){
//            print("destory")
        }
        
       
        
        
        return
    }
    
    
    
    func PathAddLineToPoint( path: CGMutablePath, _ nth: UnsafePointer<CGAffineTransform>,_ x : CGFloat,_ y: CGFloat) -> (){
        let tempx = x * scaleX
        let tempy: CGFloat = y * scaleY
        var sprite = self.getSprite()! as! SKSpriteNode
        let offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
        let offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
        CGPathAddLineToPoint(path, nil, CGFloat(tempx) - offsetX , CGFloat(tempy) - offsetY);
    }
    
    func PathMoveToPoint( path: CGMutablePath, _ nth: UnsafePointer<CGAffineTransform>,_ x : CGFloat,_ y: CGFloat) -> (){
        let tempx = x * scaleX
        let tempy: CGFloat = y * scaleY
        var sprite = self.getSprite()! as! SKSpriteNode
        let offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
        let offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
        CGPathMoveToPoint(path, nil, CGFloat(tempx) - offsetX , CGFloat(tempy) - offsetY);
        
    }
    
   var prevAction :SKAction? = nil
    var animating : Bool = false
    func expandComplete(){
        
        getSprite()!.runAction(prevAction!.reversedAction(), completion: completeShake)
    }
    func completeShake(){
        animating = false
    }
    
    func shaking(){
        
   
        if (totDmg < 80){
            prevScale =  totDmg * 0.1 / 80
        }else{
            prevScale = 0.1
        }
        var oriSize = (getSprite()! as! SKSpriteNode).size
        //(getSprite()! as! SKSpriteNode).size = CGSize(width: prevScale * oriSize.width, height: prevScale *  oriSize.height)
        prevAction = SKAction.resizeByWidth(prevScale * oriSize.width, height: prevScale * oriSize.height, duration: 0.1)
        animating = true
       getSprite()!.runAction(prevAction!, completion: expandComplete)
        scaled = true
        
    }
    
    override func update() {
        if (totDmg != 0 && animating == false){
            shaking()
        }
        totDmg = 0
        if (hp < disappearThreshold){
            //destory self and inside packet
            destorySelf()
        }
        
        
    }
    
    
    func destorySelf(){
        for obj in self.packets{
            if (obj.deleted == false){
                obj.deleteSelf()
            }
        }
        
        self.gameScene!.gameLayer!.removeGameObject(self)
        
    }
    
    
}