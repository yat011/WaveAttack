//
//  GameObject.swift
//  WaveAttack
//
//  Created by yat on 11/9/2015.
//
//

import Foundation
import SpriteKit

class GameObject : Hashable, Equatable {
    
    var hashValue: Int { return unsafeAddressOf(self).hashValue }

    
    public func getSprite() -> SKNode?{
        return nil;
    }
    
    public func update() -> (){
        
    }
    
}

func ==(lhs: GameObject, rhs: GameObject) -> Bool {
    return lhs === rhs
}