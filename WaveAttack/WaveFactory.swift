//
//  TextureGenerator.swift
//  WaveAttack
//
//  Created by James on 25/9/15.
//
//

import Foundation
import SpriteKit
class WaveFactory {
    enum WaveType:String{
        case custom = "custom"
        case flat = "flat"
        case sine1 = "sine1"
        case sine2 = "sine2"
        case sine3 = "sine3"
        case sine4 = "sine4"
        case square1 = "square1"
        case square2 = "square2"
        case square3 = "square3"
        case square4 = "square4"
        case exp1 = "exp1"
        case exp2 = "exp2"
        case exp3 = "exp3"
        case exp4 = "exp4"
    }
    static var Sine1:CGMutablePathRef{
        let path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddQuadCurveToPoint(path, nil, 0.617, 1.03, 1.0, 1.0)//quadratic bezier approximation of sine partition
        return path
    }
    static var Sine2:CGMutablePathRef{
        let path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddQuadCurveToPoint(path, nil, 0.383, 0.03, 1.0, -1.0)
        return path
    }
    static var Sine3:CGMutablePathRef{
        let path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddQuadCurveToPoint(path, nil, 0.617, -1.03, 1.0, -1.0)
        return path
    }
    static var Sine4:CGMutablePathRef{
        let path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddQuadCurveToPoint(path, nil, 0.383, -0.03, 1.0, 1.0)
        return path
    }
    static func customWave(data:[CGFloat])->CGMutablePathRef{
        let path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        
        //draw
        
        return path
    }
    static func addPath(path1:CGMutablePathRef, inout transform:CGAffineTransform, waveType:String, length:Int, height:CGFloat, directConnect:Bool){
        
        let prefab:CGMutablePathRef?
        switch (WaveType(rawValue: waveType)!)
        {
        case .sine1:
            prefab=Sine1
        case .sine2:
            prefab=Sine2
        case .sine3:
            prefab=Sine3
        case .sine4:
            prefab=Sine4
        default:
            prefab=nil
        }
        let localTransform:CGAffineTransform
        let path2:CGMutablePathRef?
        if (prefab != nil)
        {
            localTransform=CGAffineTransformMakeScale(CGFloat(length), height)
            path2=CGPathCreateMutableCopyByTransformingPath(prefab, PointerHelper.toPointer(&localTransform))!
        }
        else {path2=nil}
        
        CGPathAddPath(path1, PointerHelper.toPointer(&transform), path2)
        
        transform=CGAffineTransformTranslate(transform, CGPathGetCurrentPoint(path2).x, CGPathGetCurrentPoint(path2).y)
    }
}