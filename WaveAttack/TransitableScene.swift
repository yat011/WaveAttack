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
/*
    var interactables:[Interactable]=[Interactable]()
    var touchable:Bool=true
    var touching:Bool=false
    var prevTouch:Interactable?=nil
    var prevPoint:CGPoint?=nil
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touchable {
            if (touches.count > 0){
                if let touch = touches.first{
                    for i in interactables{
                        if i.checkTouch(touch){
                            
                        }
                    }
                }
            }
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touchable {
            if (touches.count > 0){
                if let touch = touches.first{
                    for i in interactables{
                        if i.checkTouch(touch){
                            
                        }
                    }
                }
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touchable {
            if (touches.count > 0){
                if let touch = touches.first{
                    for i in interactables{
                        if i.checkTouch(touch){
                            
                        }
                    }
                }
            }
        }
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if touchable {
        }
    }
    
    func onClick(touched:Interactable){
        touched.click()
    }
    */
    func changeScene(nextScene:GameViewController.Scene){
        viewController.sceneTransitionForward(selfScene, nextScene: nextScene)
    }
}