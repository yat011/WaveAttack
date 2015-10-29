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
    weak var viewController:GameViewController? = nil
    var selfScene:GameViewController.Scene
    let holdTimer=SKNode()
    
    init(size: CGSize, viewController:GameViewController) {
        //init(size: CGSize, viewController:GameViewController) {
        self.viewController=viewController
        self.selfScene=GameViewController.Scene.None
        super.init(size: size)
        self.addChild(holdTimer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var interactables:[Interactable]=[Interactable]()
    var draggables: [Draggable] = []
    var touchable:Bool=true
    var touching:Bool=false
    var prevTouch:Interactable?=nil
    var prevPoint:CGPoint?=nil
    var dragNode: Draggable? = nil
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touchable {
            if (touches.count > 0){
                if let touch = touches.first{
                    touching=true
                    for i in interactables{
                        if i.checkTouch(touch){
                            prevTouch=i
                            holdTimer.runAction(SKAction.waitForDuration(1),completion:onHold)
                            break
                        }
                    }
                    if prevTouch==nil{//touch else
                        let touchPoint=touch.locationInNode(self)   //?
                        prevPoint=touchPoint
                    }
                    for drag in draggables{
                        if drag.checkTouch(touch){
                            dragNode = drag
                            break
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
                    
                    if prevTouch != nil{
                        if !(prevTouch!.checkTouch(touch)){//moved out of button
                            holdTimer.removeAllActions()
                        }
                    }
                    if prevPoint != nil{
                        let touchPoint=touch.locationInNode(self)
                        onMove(prevPoint!, p1: touchPoint)
                        prevPoint = touchPoint
 
                    }
                   
                }
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touchable {
            touching=false
            holdTimer.removeAllActions()
            if (touches.count > 0){
                if let touch = touches.first{
                    if prevTouch != nil{
                        if prevTouch!.checkTouch(touch){
                            onClick()
                        }
                    }
                }
            }
        }
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if touchable {
            prevTouch=nil
            touching=false
            holdTimer.removeAllActions()
        }
    }
    
    
    func onClick(){
        //prevTouch.onClick()
        if (prevTouch is Clickable){
            (prevTouch as! Clickable).click()
        }
    }
    func onMove(p0:CGPoint, p1:CGPoint){
        //prevTouch.onMove()
        if (dragNode != nil){
            var diff:CGVector = p1 - p0
            dragNode!.scroll(diff.dx, dy: diff.dy)
        }
    }
    func onHold(){
        //prevTouch.onHold()
    }
    
    
    func changeScene(nextScene:GameViewController.Scene){
        viewController!.sceneTransitionForward(selfScene, nextScene: nextScene)
    }
}