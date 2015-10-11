//
//  MathHelper.swift
//  WaveAttack
//
//  Created by James on 7/10/15.
//
//

import Foundation
import SpriteKit

class MathHelper{
    static let PI = CGFloat(3.141592654)
    
    
    static func boundsToCGRect(x1:Int, x2:Int, y1:Int, y2:Int)->CGRect{
        var x=x1
        var y=y1
        var w=x2-x1
        var h=y2-y1
        if (x1>x2){x = x2; w = -w}
        if (y1>y2){y = y2; h = -h}
        return CGRect(x: x, y: y, width: w, height: h)
    }
    static func boundsToCGRect(x1:CGFloat, x2:CGFloat, y1:CGFloat, y2:CGFloat)->CGRect{
        var x=x1
        var y=y1
        var w=x2-x1
        var h=y2-y1
        if (x1>x2){x = x2; w = -w}
        if (y1>y2){y = y2; h = -h}
        return CGRect(x: x, y: y, width: w, height: h)
    }
}