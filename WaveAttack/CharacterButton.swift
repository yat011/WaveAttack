//
//  Team_CharacterButton.swift
//  WaveAttack
//
//  Created by James on 21/10/15.
//
//

import Foundation
import SpriteKit

class CharacterButton:SKSpriteNode,Interactable{
    var character:Character
    init(x:Int, y:Int, character:Character) {
        self.character=character
        super.init(texture: nil, color: UIColor.cyanColor(), size: CGSize(width: 40, height: 40))
        updateGraphics()
        self.position=CGPoint(x: x, y: y)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onHold(){
        let scene=(self.scene! as! TransitableScene)
        scene.viewController.sceneTransitionSK(scene.selfScene, nextScene:CharScene(size: scene.size, viewController: scene.viewController, character:character))
    }
    
    func getClass()->String{
        return "CharacterButton"
    }
    func updateGraphics(){
        self.texture=character.getIcon()
    }
}