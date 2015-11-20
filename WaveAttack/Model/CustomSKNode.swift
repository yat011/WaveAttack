//
//  CustomSKNode.swift
//  WaveAttack
//
//  Created by yat on 13/9/2015.
//
//

import Foundation
import SpriteKit



class GameSKShapeNode : SKShapeNode , HasGameObject{
   weak var _gameObject :AnyObject? = nil
    var gameObject: AnyObject? {
        get{ return _gameObject}
        set(value) { _gameObject = value}
    }
   
}

class GameSKSpriteNode: SKSpriteNode, HasGameObject{
   weak var _gameObject :AnyObject? = nil
    var gameObject: AnyObject? {
        get{ return _gameObject}
        set(value) { _gameObject = value}
    }
    
    
}



protocol HasGameObject {
    var gameObject :AnyObject? { get set}
    //func setGameObject(obj : GameObject) -> ()
}

extension HasGameObject where Self: SKNode{

    mutating func setGameObject(obj : GameObject) -> () {
        self.gameObject = obj
    }
}