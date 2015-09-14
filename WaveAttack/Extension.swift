//
//  Extension.swift
//  WaveAttack
//
//  Created by yat on 14/9/2015.
//
//

import Foundation
import SpriteKit

extension CGVector {
    
    mutating func normalize()->(){
        var len = sqrt( self.dx * self.dx + self.dy * self.dy)
        self.dx /= len
        self.dy /= len
    
    }
    
}