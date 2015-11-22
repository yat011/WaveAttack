//
//  HealSkill.swift
//  WaveAttack
//
//  Created by yat on 9/11/2015.
//
//

import Foundation
import SpriteKit
class HealSkill :SimpleSkill{
    var healAmount : CGFloat = 100
    weak var player : Player? = nil
   
    func initialize(healAmount: CGFloat, player :Player){
       
        self.healAmount = healAmount
        self.player = player
    }
    override func perform(gameScene: GameScene, character: Character) {
        gameScene.player?.changeHpBy(healAmount)
        character.cdSkill()
    }
}