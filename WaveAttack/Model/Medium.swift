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
}