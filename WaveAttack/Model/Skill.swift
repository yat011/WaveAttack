//
//  Skill.swift
//  WaveAttack
//
//  Created by yat on 4/10/2015.
//
//

import Foundation

protocol Skill{
    
    
}


protocol DecisionSkill : Skill{
    
}

protocol SimpleSkill : Skill{
    
}

protocol TargetSkill : DecisionSkill{
    
}

protocol PlacableSkill :DecisionSkill{
    func createGameObj(zIndex: Int, gameScene: GameScene) -> GameObject
}