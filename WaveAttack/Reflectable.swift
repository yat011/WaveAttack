//
//  Reflectable.swift
//  WaveAttack
//
//  Created by yat on 15/9/2015.
//
//

import Foundation
import SpriteKit

protocol Reflectable : Cloneable {
    func doReflection(from from : Medium? , to to : Medium?, contact: ContactInfo?) -> EnergyPacket?
}

extension Reflectable where Self: EnergyPacket{
    func doReflection(from from : Medium? , to to : Medium?, contact: ContactInfo?) -> EnergyPacket?
    {
        
        let reflect = self as Reflectable
       // print(self.sprite.physicsBody!.allContactedBodies())
        let rePacket = reflect.clone() as! EnergyPacket
        
        var refractive: CGFloat = CGFloat( from!.propagationSpeed / to!.propagationSpeed)
        var normal = contact!.contactNormal
        normal.normalize()
        self.direction.normalize()
        let cosine = -1 * self.direction.dot(normal)
        var sine = sqrt( 1 - pow(cosine, 2))
        var out =  -1 *  self.direction + 2 * ( direction +  cosine * normal)
        out.normalize()
        rePacket.direction = out
        rePacket.sprite.physicsBody!.velocity = rePacket.getMovement()
      //  print(rePacket.sprite.physicsBody!.allContactedBodies())
      //  rePacket.sprite.runAction(SKAction.moveBy( rePacket.direction, duration: 0))
        
        return rePacket
       
        
    }
    func clone() -> AnyObject? {
        
        
        let packet =   self.newInstance() as! EnergyPacket
        packet.belongTo.appendContentsOf(self.prevBelongTo)
        packet.gameLayer = self.gameLayer
        packet.direction = self.direction
      //  packet.sprite = self.sprite.copy() as! GameSKShapeNode
        packet.sprite.gameObject = packet
        return packet
    }
}

