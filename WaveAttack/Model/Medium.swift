//
//  Medium.swift
//  WaveAttack
//
//  Created by yat on 13/9/2015.
//
//

import Foundation
import SpriteKit
class Medium : GameObject {
    
    var propagationSpeed : Double = 3
    var zIndex: Int = 0
    var path : CGPath? { get { return nil}}
    var collisionAbsorption: CGFloat = 0
    var packets = Set<EnergyPacket>()
    
    override init(){
        super.init()
    }
    
    init(size : CGSize , position : CGPoint, gameScene :GameScene){
        
        super.init()
        initialize(size, position: position, gameScene: gameScene)
    }
    func initialize(size : CGSize , position : CGPoint, gameScene :GameScene){
        fatalError("not implement")
    }
    
    
    func addPacketRef ( packet: EnergyPacket){
        packets.insert(packet)
        
    }
    func removePacketRef (packet: EnergyPacket){
        packets.remove(packet)
    }
}