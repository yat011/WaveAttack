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
    var length:Int
    var waveData:[CGFloat]?
    var componentList:[waveComponent]
    class waveComponent {
        init (type:String, length:Int, height:CGFloat)
        {
            self.type=type
            self.length=length
            self.height=height
        }
        init (type:String, length:Int, height:CGFloat, custom:[CGFloat])
        {
            self.type=type
            self.length=length
            self.height=height
            self.custom=custom
        }
        var type:String
        var length:Int
        var height:CGFloat
        var custom:[CGFloat]?
    }
    init(){
        componentList=[waveComponent]()
        ///*
        length=300
        componentList.append(waveComponent(type: "sine1", length: 50, height: 10))
        componentList.append(waveComponent(type: "sine2", length: 100, height: 10))
        componentList.append(waveComponent(type: "sine1", length: 100, height: -10))
        componentList.append(waveComponent(type: "sine2", length: 50, height: -10))
        //*/
        /*
        length=400
        componentList.append(waveComponent(type: "sine1", length: 50, height: 5))
        componentList.append(waveComponent(type: "sine2", length: 50, height: -5))
        componentList.append(waveComponent(type: "sine1", length: 50, height: 5))
        componentList.append(waveComponent(type: "sine2", length: 50, height: 5))
        componentList.append(waveComponent(type: "sine1", length: 50, height: -5))
        componentList.append(waveComponent(type: "sine2", length: 50, height: 5))
        componentList.append(waveComponent(type: "sine1", length: 50, height: -5))
        componentList.append(waveComponent(type: "sine2", length: 50, height: -5))
        */
    }
    func genShape(){
        let path:CGMutablePathRef=CGPathCreateMutable()
        var transform:CGAffineTransform=CGAffineTransformIdentity
        CGPathMoveToPoint(path, nil, 0, 0)
        for _ in 1...1 //repeat 2-3 times for looping
        {
            for c in componentList
            {
                WaveFactory.addPath(path, transform: &transform, waveType: c.type, length: c.length, height: c.height, directConnect: true)
            }
            /*
            WaveFactory.addPath(path, transform: &transform, waveType: "sine1", length: 50, height: 10, directConnect: true)
            WaveFactory.addPath(path, transform: &transform, waveType: "sine2", length: 100, height: 10, directConnect: true)
            WaveFactory.addPath(path, transform: &transform, waveType: "sine1", length: 100, height: -10, directConnect: true)
            WaveFactory.addPath(path, transform: &transform, waveType: "sine2", length: 50, height: -10, directConnect: true)
            */
        }
        var test=[CGFloat]()
        for _ in 1...100{
            test.append(CGFloat(random()%50))
        }
        //var test=getAmplitudes()
        /*
        for i in 0...test.count-1{
            let j=random()%test.count
            var temp=test[j]
            test[j]=test[i]
            test[i]=temp
        }
*/
        CGPathAddPath(path, PointerHelper.toPointer(&transform), WaveFactory.customWave(test))
        shape=SKShapeNode(path: path)
    }
    func getShape()->SKShapeNode{
        if (shape==nil){genShape()}
        return shape!
    }
    func calAmplitudes(){
        var displace=CGFloat(0)
        waveData=[CGFloat]()
        for c in componentList{
            let c1:WaveFactory.waveComponent=WaveFactory.stringToClass(c.type)!
            for i in 0...c.length-1{
                //print((c1.dynamicType.getAmp(CGFloat(i)/CGFloat(c.length))-c1.dynamicType.start)*c.height+displace)
                waveData?.append((c1.dynamicType.getAmp(CGFloat(i)/CGFloat(c.length))-c1.dynamicType.start)*c.height+displace)
            }
            displace=displace+c1.dynamicType.displace*c.height
        }
    }
    func getAmplitudes()->[CGFloat]{
        if (waveData == nil){calAmplitudes()}
        return waveData!
    }
    func getAmplitude(x:Int)->CGFloat{
        return getAmplitudes()[x]
    }
    static func superposition(w1:Wave, w2:Wave)->Wave{
        let w=Wave()
        w.waveData=[CGFloat]()
        for i in 0...w.length-1{
            w.waveData?.append(w1.getAmplitude(i)+w2.getAmplitude(i))
        }
        return Wave()
    }
    static func squared(w:Wave)->Wave{
        for i in 1...w.waveData!.count{
            w.waveData![i] = w.waveData![i]*w.waveData![i]
        }
        return w
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
        return w
    }
}