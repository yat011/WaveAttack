//
//  TextureGenerator.swift
//  WaveAttack
//
//  Created by James on 25/9/15.
//
//

import Foundation
import SpriteKit
class TextureGenerator {
    static var Sine1:CGMutablePathRef{
        var path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddQuadCurveToPoint(path, nil, 9.7, 10.3, 15.70796, 10.0)
        return path
    }
    static var Sine2:CGMutablePathRef{
        var path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddQuadCurveToPoint(path, nil, 6.00796, 0.3, 15.70796, -10.0)
        return path
    }
    static var Sine3:CGMutablePathRef{
        var path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddQuadCurveToPoint(path, nil, 9.7, -10.3, 15.70796, -10.0)
        return path
    }
    static var Sine4:CGMutablePathRef{
        var path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddQuadCurveToPoint(path, nil, 6.00796, -0.3, 15.70796, 10.0)
        return path
    }
    static func WaveToTexture() -> SKShapeNode{
        var transform:CGAffineTransform=CGAffineTransformIdentity
        
        var transformPointer:UnsafePointer<CGAffineTransform>=toPointer(&transform)
        var path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddPath(path, nil, Sine1)
        print(transformPointer.memory)
        transform=CGAffineTransformTranslate(transform, CGPathGetCurrentPoint(Sine1).x, CGPathGetCurrentPoint(Sine1).y)
        transformPointer=toPointer(&transform)
        print(transformPointer.memory)
        CGPathAddPath(path, toPointer(&transform), Sine2)
        transform=CGAffineTransformTranslate(transform, CGPathGetCurrentPoint(Sine2).x, CGPathGetCurrentPoint(Sine2).y)
        CGPathAddPath(path, toPointer(&transform), Sine3)
        transform=CGAffineTransformTranslate(transform, CGPathGetCurrentPoint(Sine2).x, CGPathGetCurrentPoint(Sine2).y)
        CGPathAddPath(path, toPointer(&transform), Sine4)
        /*
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddQuadCurveToPoint(path, nil, 21.715926, 10.3, 31.41592, 0.0)
*/
        return SKShapeNode(path: path)}
    static func toPointer(p: UnsafePointer<CGAffineTransform>)->UnsafePointer<CGAffineTransform>{
        return p
    }
}