//
//  File.swift
//  WaveAttack
//
//  Created by yat on 1/10/2015.
//
//

import Foundation
import SpriteKit

protocol EnemyActable{
   
    var Action : EnemyAction {get}
    var leftRound : Int { get}
    func nextRound(finish: (() -> ()))
}

extension EnemyActable where Self : DestructibleObject{
    
    var leftRound : Int {
        get{
            var dis = (moveRound - currentRound - 1 )
            if dis == 0{ dis = moveRound}
            return dis
        }
    }
    
    func nextRound(finish: (() -> ())) {
        currentRound = (currentRound + 1) % moveRound
        
        if currentRound == (moveRound - 1){
            //do action
            self.Action.runAction(finish)
        }else{
            //do nth
            finish()
        }
        triggerEvent(GameEvent.RoundChanged.rawValue)
    }
}