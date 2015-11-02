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
/*
                    let touchPoint=touch.locationInNode(self)   //?
                    prevPoint=touchPoint
*/
                    for i in interactables{
                        if i.checkTouch(touch){
                            prevTouch=i
                            holdTimer.runAction(SKAction.waitForDuration(1),completion:onHold)
                            break
                        }
                    }
                    if prevTouch == nil{
                        let touchPoint=touch.locationInNode(self)   //?
                        prevPoint=touchPoint
                    }
/*
                    for scroll in scrollable{
                        if scroll.checkTouch(touch){
                            prevScroll = scroll
                            break
                        }
                    }
*/
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
                        else{
                            //onDrag(prevPoint!, p1: touchPoint)
                        }
                    }
                    else if prevPoint != nil{
                        let touchPoint=touch.locationInNode(self)
                        onDrag(prevPoint!, p1: touchPoint)
                        prevPoint = touchPoint
                    }
/*
                    else if prevScroll != nil{
                        if !(prevScroll!.checkTouch(touch)){//moved out of button
                    
                        }
                        else{
                            onScroll(prevPoint!, p1: touchPoint)
                        }
                    }
*/
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
                    else {touchable=true}
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
        //prevTouch!.onMove()
        if (dragNode != nil){
            var diff:CGVector = p1 - p0
            dragNode!.scroll(diff.dx, dy: diff.dy)
        }
    }
    func onDrag(p0:CGPoint, p1:CGPoint){
        if prevTouch != nil{
            //prevTouch!.onDrag()
            //drag component
        }
        else{
            //drag scene
        }
    }
    func onScroll(p0:CGPoint, p1:CGPoint){
/*
        if prevScroll != nil{
            //prevScroll!.onDrag()
        }
*/
    }
    func onHold(){
        //prevTouch!.onHold()
    }
    
    
    func changeScene(nextScene:GameViewController.Scene){
        viewController!.sceneTransitionForward(selfScene, nextScene: nextScene)
    }
}