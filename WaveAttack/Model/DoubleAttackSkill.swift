//
//  DoubleAttackSkill.swift
//  WaveAttack
//
//  Created by yat on 22/11/2015.
//
//

import Foundation
import SpriteKit
class DoubleAttackSkill : SimpleSkill{
 
    var character : Character? = nil
    var firstUse = true
    var using = false

    override func perform(gameScene: GameScene,character: Character){
       gameScene.player?.numOfOscillation *= 2
        using = true
        if firstUse{
            var doneFunc : ((obj:GameObject, nth:AnyObject?)->()) =  {
                (obj: GameObject, nth) in
                if self.using {
                   self.gameScene!.player!.numOfOscillation = self.gameScene!.player!.originNumOscillation
                    character.cdSkill()
                }
                self.using = false
                
            }
            self.character = character
            gameScene.controlLayer?.eventHandler.subscribeEvent(GameEvent.AttackDone.rawValue, call:doneFunc)
        }
        
        firstUse = false
        
    }
}