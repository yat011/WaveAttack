//
//  FrameTimer.swift
//  WaveAttack
//
//  Created by yat on 11/11/2015.
//
//

import Foundation
import SpriteKit
class FrameTimer : GameObject{
   typealias callBack = (()->())
    var running = false
    var target:Int  = 0
    var current : Int = 0
    var whens = [(CGFloat,callBack )]()
    var currentTime : CGFloat {
        get{
            return CGFloat(current) / CGFloat(GameViewController.fixedFps)
        }
    }
    var progress : CGFloat {
        get{
            return CGFloat(current)/CGFloat(target)
        }
    }
    var completion : (()->())? = nil
    var updateFunc : (()->())? = nil
    init (duration : CGFloat){
        target = Int( duration * CGFloat(GameViewController.fixedFps))
        super.init()
    }
    func reset(){
        current = 0
        running = false
    }
    func setTargetTime(duration: CGFloat){
        target = Int( duration * CGFloat(GameViewController.fixedFps))
    }
  
    
    override func update() {
        if running{
            current++
            updateFunc?()
            if current >= target{
                running = false
                completion?()
            }
        }
    }
    func startTimer (completion : (()->())?){
        running = true
        self.completion = completion
    }
    func stopTimer(){
        running = false
    }
    
    func subscribeWhen (time : CGFloat , call:(()->())){
       
    }
    
}