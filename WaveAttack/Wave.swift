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
    var texture : SKTexture? = nil
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
        
       // componentList.append(waveComponent(type: "sine1", length: 50, height: 10))
       // componentList.append(waveComponent(type: "sine2", length: 100, height: 10))
       // componentList.append(waveComponent(type: "sine1", length: 100, height: -10))
        //componentList.append(waveComponent(type: "sine2", length: 50, height: -10))
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
    
    
    func genShape()->SKNode{
        let path:CGMutablePathRef=CGPathCreateMutable()
        var transform:CGAffineTransform=CGAffineTransformIdentity
        CGPathMoveToPoint(path, nil, 0, 0)
        if (waveData != nil){
            CGPathAddPath(path, PointerHelper.toPointer(&transform), WaveFactory.customWave(getAmplitudes()))
        }
        else{
            for _ in 1...3 //repeat 2-3 times for looping
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
        }
/*
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
*/
        
        if texture == nil{
            var temp = SKShapeNode(path: path)
            temp.zPosition = -1000
          //  temp.position = CGPoint(x: 0, y: 0)
           
            GameScene.current!.addChild(temp)
                
           // temp.hidden = true
            texture  = GameScene.current!.view!.textureFromNode(temp)
           // temp.removeFromParent()
            //texture?.filteringMode = SKTextureFilteringMode.Nearest
            temp.removeFromParent()
        }
        var scale:CGFloat = 1
        if (UIScreen.mainScreen().scale == 2){
            scale = 0.5
        }
        var res = SKSpriteNode(texture: texture, size: CGSize(width: texture!.size().width * scale, height: texture!.size().height * scale))
        res.anchorPoint = CGPoint(x:0, y:0.5)
        
        
        return res
    }
    func getShape()->SKNode{
        if (shape==nil){}
        return genShape()
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
        if (waveData == nil){
            calAmplitudes()
        }
        
        return waveData!
    }
    func getAmplitude(x:Int)->CGFloat{
        return getAmplitudes()[x]
    }
    
    
    func superposition(var d1:Int, w2:Wave, var d2:Int){
        
        d1=d1%300
        d2=d2%300
        if (waveData==nil) {calAmplitudes()}
        for _ in 0...length-1{
            waveData![d1]+=w2.getAmplitude(d2)
            d1=(d1+1)%300
            d2=(d2+1)%300
        }
    }
    static func superposition(w1:Wave, var d1:Int, w2:Wave, var d2:Int)->Wave{
        d1=d1%300
        d2=d2%300
        let w=Wave()
        w.waveData=[CGFloat]()
        for _ in 0...w.length-1{
            w.waveData?.append(w1.getAmplitude(d1)+w2.getAmplitude(d2))
            d1=(d1+1)%300
            d2=(d2+1)%300
        }
        return w
    }
    
    static func squared(w:Wave)->Wave{
        for i in 1...w.waveData!.count{
            w.waveData![i] = w.waveData![i]*w.waveData![i]
        }
        return w
    }
    func normalize(){
        var maxAmp:CGFloat=0
        for wd in waveData!{
            if (abs(wd)>maxAmp){
                maxAmp = abs(wd)
            }
        }
        for i in 0...waveData!.count-1{
           // waveData![i] /= maxAmp
            //waveData![i] *= 0
        }
    }
    static func normalize(w:Wave)->Wave{
        w.normalize()
        return w
    }
}