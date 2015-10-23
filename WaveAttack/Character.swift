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


class Character{
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
    var round : Int { get{return _round} set(v) {
        _round = v
        oriRound = _round
        }}
    var oriRound :Int = 0
    init(){
        //.
        //.
        //.
        str=0
        ID=0
        name=""
        lore=""
        texture=SKTexture()
    }
    
    func useSkill(){
        //prevPressObj ??
        
        // find skill
        
        //temp ------
        guard skill != nil && round == 0 else{
            return
        }
        
        
        
        if (skill! is SimpleSkill){
            skill!.perform()
            _round = oriRound
        }else{
            GameScene.current!.setPendingSkill(self)
        }
        
        
    }
    func resetRound(){
        print("reset Round")
        _round = oriRound
    }
    
    func nextRound(){
        print("nextRound")
        currentSpeed = CGFloat(rand()) / CGFloat(RAND_MAX) * (maxSpeed - minSpeed) + minSpeed
        guard round > 0 else{
            return
        }
        _round--
    }
    
    func moveWave(){
        waveUI?.scroll(currentSpeed, dy: 0)
    }
    
    
    func getWave()->Wave{
        return wave!
    }
}