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
    
    var running = false
    var target:Int  = 0
    var current : Int = 0
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
}