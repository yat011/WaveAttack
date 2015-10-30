//
//  BackButton.swift
//  WaveAttack
//
//  Created by James on 25/10/15.
//
//

import Foundation
import SpriteKit

class BackButton:SKSpriteNode,Interactable{
    
    func getClass()->String{
        return "BackButton"
    }
    func onClick(){
        (self.scene! as! TransitableScene).viewController.sceneTransitionBackward()
    }
}