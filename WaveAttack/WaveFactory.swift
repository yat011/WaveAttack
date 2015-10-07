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
        case square1 = "square1"
        case square2 = "square2"
        case exp1 = "exp1"
        case exp2 = "exp2"
        case saw1 = "saw1"
        case saw2 = "saw2"
    }
    class waveComponent{
        class var path:CGMutablePathRef{return CGPathCreateMutable()}
        class func getAmp(x:CGFloat)->CGFloat{return CGFloat(0)}
        class var start:CGFloat{return CGFloat(0)}
        class var displace:CGFloat{return CGFloat(0)}
    }
    class Sine1:waveComponent{
        override class var path:CGMutablePathRef{
            let path:CGMutablePathRef=CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 0, 0)
            CGPathAddQuadCurveToPoint(path, nil, 0.617, 1.03, 1.0, 1.0)//quadratic bezier approximation of sine partition
            return path
        }
        override class func getAmp(x:CGFloat)->CGFloat{
            return sin(x*MathHelper.Pi/2)
        }
        override class var start:CGFloat{return CGFloat(0)}
        override class var displace:CGFloat{return CGFloat(1)}
    }
    class Sine2:waveComponent{
        override class var path:CGMutablePathRef{
            let path:CGMutablePathRef=CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 0, 0)
            CGPathAddQuadCurveToPoint(path, nil, 0.383, 0.03, 1.0, -1.0)
            return path
        }
        override class func getAmp(x:CGFloat)->CGFloat{
            return sin((x+1)*MathHelper.Pi/2)
        }
        override class var start:CGFloat{return CGFloat(1)}
        override class var displace:CGFloat{return CGFloat(-1)}
    }
    static func customWave(data:[CGFloat])->CGMutablePathRef{
        let path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, data[0])
        //print("new custom wave path")
        for i in 1...data.count-1{
            CGPathAddLineToPoint(path, nil, CGFloat(i), data[i])
            //print(data[i])
        }
        
        return path
    }
    static func addPath(path1:CGMutablePathRef, inout transform:CGAffineTransform, waveType:String, length:Int, height:CGFloat, directConnect:Bool){
        
        let prefab:CGMutablePathRef?
        
        prefab=stringToPath(waveType)
        
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
    
    static func stringToPath(waveType:String)->CGMutablePathRef?{
        return typeToPath(stringToType(waveType))
    }
    static func stringToClass(waveType:String)->waveComponent?{
        return typeToClass(stringToType(waveType))
    }
    
    static func stringToType(waveType:String)->WaveType{
        return WaveType(rawValue: waveType)!
    }
    static func typeToClass(waveType:WaveType)->waveComponent?{
        switch (waveType)
        {
        case .sine1:
            return Sine1()
        case .sine2:
            return Sine2()
        default:
            return nil
        }
    }
    static func typeToPath(waveType:WaveType)->CGMutablePathRef?{
        switch (waveType)
        {
        case .sine1:
            return Sine1.path
        case .sine2:
            return Sine2.path
        default:
            return nil
        }
    }
}