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
    func doRefraction(from from : Medium? , to to : Medium?, contact: ContactInfo?) -> ()
    
}

extension Refractable where Self: EnergyPacket{
    func doRefraction(from from : Medium? , to to : Medium?, contact: ContactInfo?) -> ()
    {
        //print(self.sprite.physicsBody!.allContactedBodies())
        let refractive: CGFloat = CGFloat( from!.propagationSpeed / to!.propagationSpeed)
        let c = 1 / refractive
        var normal = contact!.contactNormal
        normal.normalize()
        self.direction.normalize()
        let cosine = -1 * self.direction.dot(normal)
        let sine = sqrt( 1 - pow(cosine, 2))
    
        if (refractive < 1){
   
            if ( sine >= refractive){ // total interal reflection
                if (self is Reflectable){
                    let reflect = self as! Reflectable
                    self.gameLayer!.addGameObject(reflect.doReflection(from: from, to: to, contact: contact)!)
                    
                }
                self.deleteSelf()
                return
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
        

        
    }
    
    
    
}