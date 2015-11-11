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
        length=300
    }
    
    func fixVertical(){
        var count=componentList.count
        var i=0
        while i != count{
            let c=componentList[i]
            if c.type=="saw1"{
                c.type="line"
                if c.length>1{
                    componentList.insert(waveComponent(type: "line", length: 1, height: c.height), atIndex: i)
                    c.length--
                    c.height = -(c.height)
                    i++
                    count++
                }
                else{
                    c.height=0
                }
            }
            else if c.type=="saw2"{
                c.type="line"
                if c.length>1{
                    componentList.insert(waveComponent(type: "line", length: 1, height: -(c.height)), atIndex: i+1)
                    c.length--
                    i++
                    count++
                }
                else{
                    c.height=0
                }
            }
            else if c.type=="square1"{
                c.type="line"
                if c.length>1{
                    componentList.insert(waveComponent(type: "line", length: 1, height: c.height), atIndex: i)
                    c.length--
                    c.height=0
                    i++
                    count++
                }
            }
            else if c.type=="square2"{
                c.type="line"
                if c.length>1{
                    componentList.insert(waveComponent(type: "line", length: 1, height: -(c.height)), atIndex: i+1)
                    c.length--
                    c.height=0
                    i++
                    count++
                }
                else{
                    c.height = -(c.height)
                }
            }
            i++
        }
    }
    
    func genShape()->SKNode{
        let path:CGMutablePathRef=CGPathCreateMutable()
        var transform:CGAffineTransform=CGAffineTransformIdentity
        CGPathMoveToPoint(path, nil, 0, 0)
        var totLen: CGFloat = 0
     
        if (waveData != nil){
            CGPathAddPath(path, PointerHelper.toPointer(&transform), WaveFactory.customWave(getAmplitudes()))
            totLen = CGFloat(getAmplitudes().count - 1)
        }
        else{
            for _ in 1...3 //repeat 2-3 times for looping
            {
                for c in componentList
                {

                    WaveFactory.addPath(path, transform: &transform, waveType: c.type, length: c.length, height: c.height)
                   
                    totLen = totLen + CGFloat(c.length)
                }
            }
        }
        
        if texture == nil{
            
            var temp = SKShapeNode(path: path)
            temp.strokeColor = SKColor.cyanColor()
            temp.lineWidth = 1.0
           // print(temp.frame)
           // return temp
            var maxy:CGFloat = 0
           
            var lowY = temp.frame.origin.y
            var highY = temp.frame.size.height + temp.frame.origin.y
            if abs(highY) > abs(lowY){
                maxy = abs(highY)
            }else{
                maxy = abs(lowY)
            }
            temp.zPosition = -1000
          //  temp.position = CGPoint(x: 0, y: 0)
           
            GameViewController.skView!.scene!
                .addChild(temp)
     //       componentList
            //temp.hidden = true
            var cropRect = CGRect(x: 0, y: -maxy, width: 900, height: 2*maxy)
            //print (cropRect)
            texture  = GameViewController.skView!.textureFromNode(temp, crop: cropRect)
            // temp.removeFromParent()
            //texture?.filteringMode = SKTextureFilteringMode.Nearest
            temp.removeFromParent()
        }
        var scale:CGFloat = 1
        //print("\(totLen) vs \(texture!.size().width)")
        scale  = totLen / texture!.size().width
        if (UIScreen.mainScreen().scale == 2 && scale < 0.6){
            scale = 0.5
        }
       //print(texture)
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