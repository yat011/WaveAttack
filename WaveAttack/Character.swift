//
//  Character.swift
//  WaveAttack
//
//  Created by James on 8/10/15.
//
//

import Foundation
import SpriteKit
enum WaveDirection {
    case Left, Right
}


class Character : GameObject{
    var wave:Wave?
    var str:Int
    var texture:SKTexture?
    var icon:SKTexture?
    var skill:Skill?
    var ID:Int
    
    var lore:String
    var minSpeed: CGFloat {
        get{return _minSpeed}
        set(v) {
           _minSpeed = v
            randSpeed()
        }
    }
    
    var _minSpeed :CGFloat = 0
    var _maxSpeed :CGFloat = 2
    var maxSpeed :CGFloat{
        get{return _maxSpeed}
        set(v) {
            _maxSpeed = v
            currentSpeed = 0
        }
        
    }
    var direction: WaveDirection = .Right
    var currentSpeed: CGFloat = 1
    var _round: Int = 0
    weak var waveUI : UIWaveButton? = nil
    var basicAttackPower : CGFloat = 1
    var pending : Bool = false
    var hp : CGFloat = 10
    var round : Int { get{return _round} set(v) {
        _round = v
        oriRound = _round
        }}
    var oriRound :Int = 0
    var cdTime : CGFloat = 10
    var cdTimer = FrameTimer(duration: 10)
    var skillReady: Bool = true
    override init(){
        //.
        //.
        //.
        
        str=0
        ID=0
      //  name=""
        lore=""
        texture=SKTexture()
        icon=SKTexture(noiseWithSmoothness: CGFloat(0.5), size: CGSize(width: 50, height: 50), grayscale: false)

        super.init()
         name=""
    }
    func afterAddToScene(){
       cdTimer.addToGeneralUpdateList()
        cdTimer.setTargetTime(cdTime)
        self.triggerEvent(GameEvent.SkillReady.rawValue)
        gameScene!.controlLayer!.eventHandler.subscribeEvent(GameEvent.AttackDone.rawValue, call: {
            Void in
            self.currentSpeed = 0
            
        })
    }
    
    func useSkill(){
        //prevPressObj ??
        
        // find skill
        
        //temp ------
        guard skill != nil && skillReady == true else{
            return
        }
        guard pending == false else{
            pending = false
           GameScene.current!.clearSkill()
            triggerEvent(GameEvent.SkillReady.rawValue)
            return
        }
        
        
        if (skill! is SimpleSkill){
            skillReady = false
           triggerEvent(GameEvent.SKillUsed.rawValue)
            skill!.perform(GameScene.current!,character: self)
        }else{
            GameScene.current!.setPendingSkill(self)
            pending = true
            self.triggerEvent(GameEvent.SKillPending.rawValue)
        }
        
        
    }
    func cdSkill(){
        self.triggerEvent(GameEvent.SKillUsed.rawValue)
        skillReady = false
        cdTimer.reset()
        cdTimer.startTimer({
           Void in
            self.skillReady = true
            self.triggerEvent(GameEvent.SkillReady.rawValue)
        })
    }
    
  
    func randSpeed(){
       currentSpeed = CGFloat(rand()) / CGFloat(RAND_MAX) * (maxSpeed - minSpeed) + minSpeed
    }
    func canelSkill(){
        
        pending = false
        self.triggerEvent(GameEvent.SkillReady.rawValue)

        

    }
    
    func moveWave(){
        waveUI?.scroll(currentSpeed, dy: 0)
    }
    
    func changeWaveSpeed(progress: CGFloat){ // [0-1]
       currentSpeed = progress * maxSpeed
    }
    
    func getWave()->Wave{
        return wave!
    }
    func getIcon()->SKTexture?{
        return texture
    }
    func getTexture()->SKTexture?{
        return texture
    }
}