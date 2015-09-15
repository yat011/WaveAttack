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
        let len = sqrt( self.dx * self.dx + self.dy * self.dy)
        self.dx /= len
        self.dy /= len
    
    }
    
    func dot(b: CGVector) -> CGFloat{
       return self.dx * b.dx + self.dy * b.dy
    }
    
}

public func *(lhs : CGFloat, rhs: CGVector) -> CGVector{
    return CGVector(dx: lhs * rhs.dx, dy: lhs * rhs.dy)
}

public func + (lhs: CGVector, rhs: CGVector) -> CGVector{
    return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

public func - (lhs: CGVector, rhs: CGVector) -> CGVector{
    return lhs + ( -1 * rhs)
}