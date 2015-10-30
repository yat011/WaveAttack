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
    var character:Character?
    override init(size: CGSize, viewController: GameViewController) {
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