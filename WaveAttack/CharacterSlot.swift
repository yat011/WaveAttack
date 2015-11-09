//
//  CharacterSlot.swift
//  WaveAttack
//
//  Created by James on 21/10/15.
//
//

import Foundation
import SpriteKit

class CharacterSlot:SKSpriteNode,Interactable{
    var character:Character?
    var slot:Int
    init(x:Int, y:Int, slot:Int) {
        var characters = (PlayerInfo.playerInfo!.teams!.allObjects[0] as! Team).characters!.allObjects as! [OwnedCharacter]
        self.character=CharacterManager.getCharacterByID(characters[slot].characterId!.integerValue)
        self.slot=slot
        super.init(texture: nil, color: UIColor.greenColor(), size: CGSize(width: 40, height: 40))
        updateGraphics()
        self.position=CGPoint(x: x, y: y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onHold(){
        if character != nil{
            let scene=(self.scene! as! TransitableScene)
            scene.viewController!.sceneTransitionSK(scene.selfScene, nextScene:CharScene(size: scene.size, viewController: scene.viewController!, character:character!))
        }
    }
    
    func getClass()->String{
        return "CharacterSlot"
    }
    func updateGraphics(){
        if character==nil{
            self.texture=nil
        }
        else{self.texture=character!.getIcon()}
    }
}