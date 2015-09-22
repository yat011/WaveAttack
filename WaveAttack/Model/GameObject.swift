//
//  GameObject.swift
//  WaveAttack
//
//  Created by yat on 11/9/2015.
//
//

import Foundation
import SpriteKit

class GameObject : NSObject {
    
  override var hashValue: Int { return unsafeAddressOf(self).hashValue }
    weak var gameScene : GameScene? = nil
    
    func getSprite() -> SKNode?{
        return nil;
    }
    
    func update() -> (){
        
    }
    
    override init(){
        super.init()
    }
    
    init(_ gameScene :GameScene){
        self.gameScene = gameScene
    }
    
    func deleteSelf(){
        
    }
    
    
}

func ==(lhs: GameObject, rhs: GameObject) -> Bool {
    return lhs === rhs
}