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
    static var Sine1:CGMutablePathRef{
        let path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddQuadCurveToPoint(path, nil, 9.7, 10.3, 15.70796, 10.0)//quadratic bezier approximation of sine partition
        return path
    }
    static var Sine2:CGMutablePathRef{
        let path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddQuadCurveToPoint(path, nil, 6.00796, 0.3, 15.70796, -10.0)
        return path
    }
    static var Sine3:CGMutablePathRef{
        let path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddQuadCurveToPoint(path, nil, 9.7, -10.3, 15.70796, -10.0)
        return path
    }
    static var Sine4:CGMutablePathRef{
        let path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddQuadCurveToPoint(path, nil, 6.00796, -0.3, 15.70796, 10.0)
        return path
    }
    static func customWave(){
        
    }
}