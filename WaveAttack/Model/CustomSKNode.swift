//
//  CustomSKNode.swift
//  WaveAttack
//
//  Created by yat on 13/9/2015.
//
//

import Foundation
import SpriteKit

protocol HasGameObject {
    var gameObject :GameObject? { get set}
    mutating func setGameObject(obj : GameObject) -> ()
}

extension HasGameObject where Self: SKNode{
    
    mutating func setGameObject(obj : GameObject) -> () {
        self.gameObject = obj
    }
}


class GameSKShapeNode : SKShapeNode , HasGameObject{
   weak var _gameObject :GameObject? = nil
    var gameObject: GameObject? {
        get{ return _gameObject}
        set(value) { _gameObject = value}
    }
    
}

class GameSKSpriteNode: SKSpriteNode, HasGameObject{
   weak var _gameObject :GameObject? = nil
    var gameObject: GameObject? {
        get{ return _gameObject}
        set(value) { _gameObject = value}
    }
    
}



