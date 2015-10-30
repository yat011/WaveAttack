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
        
        let label =  SKLabelNode(text: "TEST")
        label.position=CGPoint(x:300, y:300)
        self.addChild(label)
        let icon = SKSpriteNode(texture: character.getIcon(), color: UIColor.clearColor(), size: CGSize(width: 50,height: 50))
        icon.position=CGPoint(x:25, y:viewController.screenSize.height-75)
        self.addChild(icon)
        
        let wave:SKNode = (character.wave?.getShape())!
        wave.position=CGPoint(x:viewController.screenSize.width/2, y:200)
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