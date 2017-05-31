//
//  Skill.swift
//  WaveAttack
//
//  Created by yat on 4/10/2015.
//
//

import Foundation
import SpriteKit
class Skill: GameObject{
    func perform(pos:CGPoint, character : Character){
        
    }
    
}


class DecisionSkill : Skill{
    
}

class SimpleSkill : Skill{
    
}

class TargetSkill : DecisionSkill{
    
}

class PlacableSkill :DecisionSkill{
   
    func createIndicator () -> SKSpriteNode{
        fatalError("not implement")
    }
    func getIndicatorPosition(pos : CGPoint)->CGPoint{
       return pos
    }
    
}