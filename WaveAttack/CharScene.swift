//
//  CharScene.swift
//  WaveAttack
//
//  Created by James on 23/10/15.
//
//

import Foundation
import SpriteKit

class CharScene:TransitableScene{
    var character:Character
    init(size: CGSize, viewController: GameViewController, character:Character) {
        self.character=character
        super.init(size: size, viewController: viewController)
        selfScene=GameViewController.Scene.CharScene
        
        let backButton=BackButton(texture: nil, size: CGSize(width: 60, height: 30))
        backButton.position=CGPoint(x:30, y:viewController.screenSize.height-20)
        backButton.color=UIColor.redColor()
        interactables.append(backButton)
        self.addChild(backButton)
        
        let idLabel =  SKLabelNode(text: character.ID.description+": ")
        idLabel.position=CGPoint(x:50, y:viewController.screenSize.height-150)
        idLabel.horizontalAlignmentMode=SKLabelHorizontalAlignmentMode.Left
        self.addChild(idLabel)
        let nameLabel =  SKLabelNode(text: character.name)
        nameLabel.position=CGPoint(x:100, y:viewController.screenSize.height-150)
        nameLabel.horizontalAlignmentMode=SKLabelHorizontalAlignmentMode.Left
        self.addChild(nameLabel)
        let hpLabel =  SKLabelNode(text: "hp: "+character.hp.description)
        hpLabel.position=CGPoint(x:50, y:viewController.screenSize.height-200)
        hpLabel.horizontalAlignmentMode=SKLabelHorizontalAlignmentMode.Left
        self.addChild(hpLabel)
        let strLabel =  SKLabelNode(text: "str: "+character.str.description)
        strLabel.position=CGPoint(x:200, y:viewController.screenSize.height-200)
        strLabel.horizontalAlignmentMode=SKLabelHorizontalAlignmentMode.Left
        self.addChild(strLabel)
        let loreLabel =  SKLabelNode(text: "lore: "+character.lore)
        loreLabel.position=CGPoint(x:50, y:viewController.screenSize.height-250)
        loreLabel.horizontalAlignmentMode=SKLabelHorizontalAlignmentMode.Left
        self.addChild(loreLabel)

        let icon = SKSpriteNode(texture: character.getIcon(), color: UIColor.clearColor(), size: CGSize(width: 50,height: 50))
        icon.position=CGPoint(x:25, y:viewController.screenSize.height-75)
        self.addChild(icon)
        
        let wave:SKNode = (character.wave?.getShape())!
        wave.position=CGPoint(x:viewController.screenSize.width/2-150, y:viewController.screenSize.height-400)
        self.addChild(wave)
    }

    override func onClick(){
        if(prevTouch?.getClass()=="BackButton"){
            touchable=false
            prevTouch!.onClick()
        }
        prevTouch=nil
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}