//
//  ConvexLenSkill.swift
//  WaveAttack
//
//  Created by yat on 4/10/2015.
//
//

import Foundation
import SpriteKit

class ConvexLenSkill : PlacableSkill{
    
    func perform(gameScene :GameScene){
        
    }
    
    func createGameObj(zIndex: Int, gameScene: GameScene) -> GameObject {
        var temp = ConvexLen()
        temp.initialize(CGSize(width: 100,height: 30), position: CGPoint(x:0,y:0), gameScene: gameScene)
        temp.target = false
        temp.zIndex = zIndex + 1
        return temp
    }
    
}