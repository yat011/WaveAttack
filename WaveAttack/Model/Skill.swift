//
//  Skill.swift
//  WaveAttack
//
//  Created by yat on 4/10/2015.
//
//

import Foundation

class Skill: GameObject{
    func perform(gameScene:GameScene, character : Character){
        
    }
    
}


class DecisionSkill : Skill{
    
}

class SimpleSkill : Skill{
    
}

class TargetSkill : DecisionSkill{
    
}

class PlacableSkill :DecisionSkill{
    func createGameObj(zIndex: Int, gameScene: GameScene) -> GameObject{
        fatalError("not implement")
    }
}