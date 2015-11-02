//
//  Player.swift
//  WaveAttack
//
//  Created by yat on 29/9/2015.
//
//

import Foundation
import SpriteKit
class Player : GameObject{
    
    var hp: CGFloat { get{return  _hp}}
    var _hp: CGFloat = 100
    var oriHp : CGFloat = 100
    init( hp: CGFloat){
        oriHp = hp
        _hp = hp
        
        super.init()
    }
    
    func changeHpBy (delta : CGFloat){
        var newHp: CGFloat = _hp + delta
        
        if newHp < 0 {
            _hp = 0
            triggerEvent(GameEvent.PlayerDead.rawValue)
        }else if (newHp > oriHp){
            _hp = oriHp
        }else{
            _hp = newHp
        }
        triggerEvent(GameEvent.HpChanged.rawValue)
        
    }
    
    
}