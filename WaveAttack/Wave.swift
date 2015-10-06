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
    var length:CGFloat?
    var waveData:[CGFloat]?
    var componentList:[waveComponent]?
    struct waveComponent {
        var type:String
        var length:Int
        var height:CGFloat
    }
    init(){
    length=300
        
    }
    
    func getShape()->SKShapeNode{
        if (shape==nil)
        {
            let path:CGMutablePathRef=CGPathCreateMutable()
            var transform:CGAffineTransform=CGAffineTransformIdentity
            CGPathMoveToPoint(path, nil, 0, 0)
            for _ in 1...3 //repeat 2-3 times for looping
            {
                /*
                for c in componentList!
                {
                    WaveFactory.addPath(path, transform: &transform, waveType: c.type, length: c.length, height: c.height, directConnect: true)
                }
                */
                WaveFactory.addPath(path, transform: &transform, waveType: "sine1", length: 50, height: 10, directConnect: true)
                WaveFactory.addPath(path, transform: &transform, waveType: "sine2", length: 100, height: 10, directConnect: true)
                WaveFactory.addPath(path, transform: &transform, waveType: "sine3", length: 100, height: 10, directConnect: true)
                WaveFactory.addPath(path, transform: &transform, waveType: "sine4", length: 50, height: 10, directConnect: true)
            }
            
            shape=SKShapeNode(path: path)
        }
        return shape!
    }
    func getAmplitude(x:Int)->CGFloat{
        /*
        var curHeight:CGFloat=0
        var curLength:Int=0
        for c in componentList!
        {
            if (x-curLength > c.length){
                curHeight = curHeight+c.height
            }
            else{
                //cal component height
            }
        }
        */
        return waveData![x]
    }
    static func superposition(w1:Wave, w2:Wave)->Wave{
        
        return Wave()
    }
    static func normalize(w:Wave)->Wave{
        var maxAmp:CGFloat=0
        for wd in w.waveData!{
            if (wd>maxAmp){
                maxAmp=wd
            }
        }
        for i in 1...w.waveData!.count{
            w.waveData![i] /= maxAmp
        }
        return Wave()
    }
}