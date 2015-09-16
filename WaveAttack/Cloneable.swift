//
//  Cloneable.swift
//  WaveAttack
//
//  Created by yat on 15/9/2015.
//
//

import Foundation
import SpriteKit
protocol Cloneable{
    func clone() -> AnyObject?
    func newInstance() -> AnyObject?
}

extension Cloneable where Self :  EnergyPacket {
    
    func clone() -> AnyObject? {
       
        
        let packet =   self.newInstance() as! EnergyPacket
        for medium in self.belongTo {
            packet.pushBelongTo(medium)
        }
        packet.gameLayer = self.gameLayer
        packet.direction = self.direction
       // packet.sprite = self.sprite.copy() as! GameSKShapeNode
        packet.sprite.gameObject = packet
        return packet
    }

}