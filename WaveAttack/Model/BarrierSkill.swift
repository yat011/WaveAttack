//
//  BarrierSkill.swift
//  WaveAttack
//
//  Created by yat on 24/11/2015.
//
//

import Foundation
import SpriteKit
class BarrierSkill: SimpleSkill {
    
    var character : Character? = nil
    var firstUse = true
    var using = false
    let radius = 40.f
    var originHp = 2000.f
    var hp = 2000.f
    var barriers = Set<Barrier>()
    override func perform(gameScene: GameScene,character: Character){
        Barrier(maxHp: originHp, skill: self)
        
       character.cdSkill()
        
    }
    

   
    
}