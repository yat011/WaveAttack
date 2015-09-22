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
    func doRefraction(from from : Medium? , to to : Medium?, contact: ContactInfo?) -> CGFloat
    
}

extension Refractable where Self: EnergyPacket{
    func doRefraction(from from : Medium? , to to : Medium?, contact: ContactInfo? ) -> CGFloat
    {
        //print(self.sprite.physicsBody!.allContactedBodies())
        
        let c = refractiveRatio
        var normal = contact!.contactNormal
        normal.normalize()
        self.direction.normalize()
        var oriDir = self.direction
        let cosine = self.cosine!
        let sine = sqrt( 1 - pow(cosine, 2))
        
        if (refractive < 1){
   
            if ( sine >= refractive){ // total internal reflection
               /* if (self is Reflectable){
                    let reflect = self as! Reflectable
                    self.gameLayer!.addGameObject(reflect.doReflection(from: from, to: to, contact: contact)!)
                    
                }*/
                //self.deleteSelf()
                var packet = self as EnergyPacket
                packet.deleteSelf()
                return 0
            }else{ //
                var out = c * self.direction
                let cost = sqrt(1 - pow(c, 2) * (1 - pow(cosine, 2)))
                // let sint = sqrt(pow(1 / refractive, 2) * (1 - pow(cosine, 2)))
                let temp = c * cosine - cost
                out = out + temp * normal
                out.normalize()
                self.direction = out
            }
        }else{
            var out = c * self.direction
            let cost = sqrt(1 - pow(c, 2) * (1 - pow(cosine, 2)))
           // let sint = sqrt(pow(1 / refractive, 2) * (1 - pow(cosine, 2)))
            let temp = c * cosine - cost
            out = out + temp * normal
            out.normalize()
          //  print("refraction : \(out) ")
            self.direction = out
        }
    
        
        var cosine2 = -1 * self.direction.dot(normal)
        
        return getTranmissionRatio(cosine, cosine2,ax: oriDir.dx)

        
    }
    
    func getTranmissionRatio (cosine1 : CGFloat, _ cosine2 :CGFloat , ax : CGFloat) -> CGFloat{
        var a = (refractiveRatio * cosine1 - cosine2) / ( refractiveRatio * cosine1 +  cosine2)
        var b = (refractiveRatio * cosine2 - cosine1) / ( refractiveRatio * cosine2 +  cosine1)
        
        
        return 1 - ( a * a + b * b) / 2 
    }
    
}