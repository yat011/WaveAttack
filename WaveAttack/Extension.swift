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

public func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint{
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func + (lhs: CGPoint, rhs: CGVector) -> CGPoint{
    return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}


public func == (lhs: CGPoint, rhs: CGPoint) -> Bool{
    return (lhs.x == rhs.x && lhs.y == rhs.y)
}

public func - (lhs: CGPoint, rhs: CGPoint) -> CGVector{
    return CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
}

public func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint{
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

