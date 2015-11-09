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
    var ownedCharacter : OwnedCharacter? = nil
    init(x:Int, y:Int, character:Character, owned:OwnedCharacter) {
        self.character=character
        self.ownedCharacter = owned
        super.init(texture: nil, color: UIColor.cyanColor(), size: CGSize(width: 40, height: 40))
        updateGraphics()
        self.position=CGPoint(x: x, y: y)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onHold(){
        let scene=(self.scene! as! TransitableScene)
        scene.viewController!.sceneTransitionSK(scene.selfScene, nextScene:CharScene(size: scene.size, viewController: scene.viewController!, character:character))
    }
    
    func getClass()->String{
        return "CharacterButton"
    }
    func updateGraphics(){
        self.texture=character.getIcon()
    }
}