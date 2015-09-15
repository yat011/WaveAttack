//
//  Protocol.swift
//  WaveAttack
//
//  Created by yat on 11/9/2015.
//
//

import Foundation
import SpriteKit
protocol Refractable{
    func doRefraction(from from : Medium? , to to : Medium?, contact: SKPhysicsContact?) -> ()
    
}

extension Refractable where Self: EnergyPacket{
    func doRefraction(from from : Medium? , to to : Medium?, contact: SKPhysicsContact?) -> ()
    {
        var refractive: CGFloat = CGFloat( from!.propagationSpeed / to!.propagationSpeed)
        var normal = contact!.contactNormal
        normal.normalize()
        self.direction.normalize()
        var cosine = -1 * self.direction.dot(normal)
        var sine = sqrt( 1 - pow(cosine, 2))
    
        
   
        if ( sine >= refractive){ // total interal reflection
            if (self is Reflectable){
                var reflect = self as! Reflectable
                self.gameLayer!.addGameObject(reflect.doReflection(from: from, to: to, contact: contact)!)
                
            }
            self.deleteSelf()
        }else{ //
            var out = refractive * self.direction
            var temp = refractive * cosine - sqrt(1 - pow(refractive, CGFloat(2)) * (pow(cosine, 2) - 1))
            out = out + temp * normal
            out.normalize()
            self.direction = out
        }
        
        
    }
}