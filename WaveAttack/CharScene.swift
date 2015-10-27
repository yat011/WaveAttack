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
        
        let backButton=BackButton(texture: nil, size: CGSize(width: 50, height: 50))
        backButton.position=CGPoint(x: 375/2, y: 300)
        backButton.color=UIColor.redColor()
        interactables.append(backButton)
        self.addChild(backButton)
    }

    override func onClick(){
        if(prevTouch?.getClass()=="BackButton"){
            touchable=false
            (prevTouch as! BackButton).click()
        }
        prevTouch=nil
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}