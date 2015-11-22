//
//  SpeedChargingSkill.swift
//  WaveAttack
//
//  Created by yat on 23/11/2015.
//
//

import Foundation
import SpriteKit

class SpeedChargingSkill: SimpleSkill{
    
    var character : Character? = nil
    var firstUse = true
    var using = false
    
    override func perform(gameScene: GameScene,character: Character){
        gameScene.player?.chargingTime /= 2
        using = true
        if firstUse{
            var doneFunc : ((obj:GameObject, nth:AnyObject?)->()) =  {
                (obj: GameObject, nth) in
                if self.using {
                    self.gameScene!.player!.chargingTime = self.gameScene!.player!.originchargingTime
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