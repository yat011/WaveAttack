//
//  NormalEnergyPacket.swift
//  WaveAttack
//
//  Created by yat on 11/9/2015.
//
//

import Foundation
import SpriteKit
class NormalEnergyPacket: EnergyPacket, Refractable, Reflectable {
    func newInstance() -> AnyObject? {
        return NormalEnergyPacket( self.energy , position: self.sprite!.position,gameScene: self.gameScene!)
    }
}

