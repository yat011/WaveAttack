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
    //var transition:[SKTransition]
    var viewController:GameViewController
    var selfScene:GameViewController.Scene
    
    init(size: CGSize, viewController:GameViewController) {
    //init(size: CGSize, viewController:GameViewController) {
        self.viewController=viewController
        self.selfScene=GameViewController.Scene.None
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeScene(nextScene:GameViewController.Scene){
        viewController.sceneTransitionForward(selfScene, nextScene: nextScene)
    }
}