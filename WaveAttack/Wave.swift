//
//  Wave.swift
//  WaveAttack
//
//  Created by James on 5/10/15.
//
//

import Foundation
import SpriteKit

class Wave{
    var shape:SKShapeNode?
    
    init(){}
    
    func getShape()->SKShapeNode{
        if (shape==nil)
        {
            var transform:CGAffineTransform=CGAffineTransformIdentity
            
            var transformPointer:UnsafePointer<CGAffineTransform>=PointerHelper.toPointer(&transform)
            
            var path:CGMutablePathRef=CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 0, 0)
            CGPathAddPath(path, nil, WaveFactory.Sine1)
            transform=CGAffineTransformTranslate(transform, CGPathGetCurrentPoint(WaveFactory.Sine1).x, CGPathGetCurrentPoint(WaveFactory.Sine1).y)
            CGPathAddPath(path, PointerHelper.toPointer(&transform), WaveFactory.Sine2)
            transform=CGAffineTransformTranslate(transform, CGPathGetCurrentPoint(WaveFactory.Sine2).x, CGPathGetCurrentPoint(WaveFactory.Sine2).y)
            CGPathAddPath(path, PointerHelper.toPointer(&transform), WaveFactory.Sine3)
            transform=CGAffineTransformTranslate(transform, CGPathGetCurrentPoint(WaveFactory.Sine2).x, CGPathGetCurrentPoint(WaveFactory.Sine2).y)
            CGPathAddPath(path, PointerHelper.toPointer(&transform), WaveFactory.Sine4)
            shape=SKShapeNode(path: path)
        }
        return shape!
    }
    func getAmplitude(x:Int)->Float{
        return 0
    }
    static func superposition(w1:Wave, w2:Wave)->Wave{
        return Wave()
    }
}