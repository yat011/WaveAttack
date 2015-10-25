//
//  TransitableScene.swift
//  WaveAttack
//
//  Created by James on 25/10/15.
//
//

import Foundation
import SpriteKit

class TransitableScene:SKScene{
    var prevScene:[GameViewController.Scene]      //will change to stack-like implementation
    //var prevScene:GameViewController.Scene?
    //var transition:[SKTransition]
    var viewController:GameViewController
    var selfScene:GameViewController.Scene
    
    init(size: CGSize, viewController:GameViewController, prevScene:[GameViewController.Scene]) {
    //init(size: CGSize, viewController:GameViewController, prevScene:GameViewController.Scene) {
        self.viewController=viewController
        self.prevScene=prevScene
        self.selfScene=GameViewController.Scene.None
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeScene(nextScene:GameViewController.Scene){
        prevScene.append(selfScene)
        viewController.changeScene(prevScene, nextScene: nextScene)
    }
}