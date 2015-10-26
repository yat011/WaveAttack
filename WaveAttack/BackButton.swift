//
//  BackButton.swift
//  WaveAttack
//
//  Created by James on 25/10/15.
//
//

import Foundation
import SpriteKit

class BackButton:SKSpriteNode,_Clickable{
    
    func getClass()->String{
        return "BackButton"
    }
    func click(){
        back()
    }
    func back(){
        (self.scene! as! TransitableScene).viewController.sceneTransitionBackward()
        /*
        let scene=(self.scene! as! TransitableScene)
        let last=scene.prevScene.removeLast()
        scene.viewController.changeScene(scene.prevScene, nextScene: last)
        */
    }
}