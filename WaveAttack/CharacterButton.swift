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
    var usingNode :SKSpriteNode
    init(x:Int, y:Int, character:Character, owned:OwnedCharacter) {
        self.character=character
        self.ownedCharacter = owned
        usingNode = SKSpriteNode(imageNamed: "using")
        usingNode.size = CGSize(width: 40,height: 40)
        usingNode.hidden = true
        usingNode.colorBlendFactor = 1
        usingNode.color = SKColor.yellowColor()
        usingNode.zPosition  = 1
        super.init(texture: nil, color: UIColor.cyanColor(), size: CGSize(width: 40, height: 40))
        
        self.addChild(usingNode)
        updateGraphics()
        self.position=CGPoint(x: x, y: y)
        
        //if ownedCharacter?.belongTo != nil{
           // showUsing()
       // }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func showUsing(){
        usingNode.hidden = false
        
    }
    func hideUsing(){
        usingNode.hidden = true
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