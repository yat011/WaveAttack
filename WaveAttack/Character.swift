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
    var texture:SKTexture
    var skill:Skill?
    var ID:Int
    var name:String
    var lore:String
    var minSpeed: CGFloat = 0
    var maxSpeed :CGFloat = 2
    var direction: WaveDirection = .Right
    var currentSpeed: CGFloat = 1
    var _round: Int = 0
    weak var waveUI : UIWaveButton? = nil
    var pending : Bool = false
    var round : Int { get{return _round} set(v) {
        _round = v
        oriRound = _round
        }}
    var oriRound :Int = 0
    override init(){
        //.
        //.
        //.
        
        str=0
        ID=0
        name=""
        lore=""
        texture=SKTexture()
        super.init()
    }
    
    func useSkill(){
        //prevPressObj ??
        
        // find skill
        
        //temp ------
        guard skill != nil && round == 0 else{
            return
        }
        guard pending == false else{
            pending = false
           GameScene.current!.clearSkill()
            triggerEvent(GameEvent.SkillReady.rawValue)
            return
        }
        
        
        if (skill! is SimpleSkill){
            skill!.perform()
            resetRound()
        }else{
            GameScene.current!.setPendingSkill(self)
            pending = true
            self.triggerEvent(GameEvent.SKillPending.rawValue)
        }
        
        
    }
    func resetRound(){
        print("reset Round")
        _round = oriRound
        pending = false
        self.triggerEvent(GameEvent.SKillUsed.rawValue)
    }
    
    func nextRound(){
        print("nextRound")
        currentSpeed = CGFloat(rand()) / CGFloat(RAND_MAX) * (maxSpeed - minSpeed) + minSpeed
        guard round > 0 else{
            return
        }
        _round--
        if round == 0 {
            self.triggerEvent(GameEvent.SkillReady.rawValue)
        }
    }
    
    func moveWave(){
        waveUI?.scroll(currentSpeed, dy: 0)
    }
    
    
    func getWave()->Wave{
        return wave!
    }
}