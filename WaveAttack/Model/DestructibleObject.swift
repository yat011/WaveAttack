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
    
    var hp : Double = 100
    var absorptionRate :Double = 0.1
    var damageReduction :Double = 0
    var scaleX: CGFloat  = 1
    var scaleY : CGFloat = 1
    
    
    func calculateDamage(packet : EnergyPacket){
        
        return
    }
    
    override init(){
        super.init()
        getSprite()!.name = "DestructibleObj"
    }
    
    func PathAddLineToPoint(var  path: CGMutablePath, _ nth: UnsafePointer<CGAffineTransform>,_ x : CGFloat,_ y: CGFloat) -> (){
        var tempx = x * scaleX
        var tempy: CGFloat = y * scaleY
        CGPathAddLineToPoint(path, nil, CGFloat(tempx) , CGFloat(tempy));
        
        
      
    }
    
    func PathMoveToPoint(var  path: CGMutablePath, _ nth: UnsafePointer<CGAffineTransform>,_ x : CGFloat,_ y: CGFloat) -> (){
        var tempx = x * scaleX
        var tempy: CGFloat = y * scaleY
        CGPathMoveToPoint(path, nil, CGFloat(tempx) , CGFloat(tempy));
        
    }
    
    
    
    
}