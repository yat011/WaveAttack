//
//  Character.swift
//  WaveAttack
//
//  Created by James on 8/10/15.
//
//

import Foundation
import SpriteKit

class Character{
    var wave:Wave?
    var str:Int
    var texture:SKTexture
    var skill:Skill?
    var ID:Int
    var name:String
    var lore:String
    var _round: Int = 0
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
        guard round > 0 else{
            return
        }
        _round--
    }
    
    func getWave()->Wave{
        return wave!
    }
}