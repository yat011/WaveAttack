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
    init(x:Int, y:Int, character:Character?) {
        self.character=character
        super.init(texture: nil, color: UIColor.greenColor(), size: CGSize(width: 40, height: 40))
        updateGraphics()
        self.position=CGPoint(x: x, y: y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onHold(){
        let scene=(self.scene! as! TransitableScene)
            scene.viewController.sceneTransitionSK(scene.selfScene, nextScene:CharScene(size: self.size, viewController: scene.viewController))
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