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
   var icon = SKSpriteNode(imageNamed: "timeDown") 
    override func perform(pos:CGPoint, character: Character) {
        let gameScene = self.gameScene!
        gameScene.player!.chargingTime /= 2
        using = true
        if firstUse == true{
            var doneFunc : ((obj:GameObject, nth:AnyObject?)->()) =  {
                (obj: GameObject, nth) in
                if self.using {
                    self.gameScene!.player!.chargingTime = self.gameScene!.player!.originchargingTime
                    character.cdSkill()
                    gameScene.infoLayer!.removeSkillIcon(self.icon)
                }
                self.using = false
                
            }
            self.character = character
            gameScene.controlLayer!.eventHandler.subscribeEvent(GameEvent.AttackDone.rawValue, call:doneFunc)
        }
       gameScene.infoLayer!.addSkillIcon(icon) 
        firstUse = false
        
    }
}