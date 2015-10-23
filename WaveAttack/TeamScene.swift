//
//  TeamScene.swift
//  WaveAttack
//
//  Created by James on 19/10/15.
//
//

import Foundation
import SpriteKit

class TeamScene: SKScene{
    var viewController:GameViewController?
    var centeredNode:SKNode
    //var clickNodes:SKNode
    var timer:SKNode
    var clickables:[_Clickable]
    var characterButtonGroup:SKNode
    var characterButtonGroupRect:CGRect
    override init(size: CGSize) {
        centeredNode=SKNode()
        centeredNode.position=CGPoint(x: 375/2, y:0)
        timer=SKNode()
        clickables=[_Clickable]()
        characterButtonGroup=SKNode()
        characterButtonGroupRect=CGRect(origin: CGPoint(x: -375/2, y: 0), size: CGSize(width: 375, height: 500))
        super.init(size: size)
        self.size=CGSize(width: 375, height: 667)
        self.addChild(centeredNode)
        var buttonX = -120
        var buttonY = 100
        //centeredNode.addChild(clickNodes)
        self.addChild(timer)
        centeredNode.addChild(characterButtonGroup)
        for c in CharacterManager.characters!{
            //make buttons
            let cb=CharacterButton(x: buttonX,y: buttonY,character: c)
            cb.name="CharacterButton"
            characterButtonGroup.addChild(cb)
            //displace next button
            buttonX += 60
            if (buttonX == 180){
                buttonX = -120
                buttonY += 100
            }
            clickables.append(cb)
        }
        for i in 0..<5{
            //make slots
            let cs=CharacterSlot(x: -120+60*i,y: 600,character: CharacterManager.getCharacterByID(CharacterManager.team[i]))
            cs.name="CharacterSlot"
            centeredNode.addChild(cs)
            clickables.append(cs)
        }
        self.backgroundColor=UIColor.blueColor()
    }
    var prevTouch:_Clickable?
    var prevPoint:CGPoint?
    var dragVelocity:CGFloat=0
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touches.count > 0){
            if let touch = touches.first{
                let touchPoint=touch.locationInNode(centeredNode)
                for c in clickables{
                    if c.checkTouch(touch){
                        prevTouch=c
                        timer.runAction(SKAction.waitForDuration(1),completion:onHold)
                        break
                    }
                }
                if prevTouch==nil{//touch else
                    prevPoint=touchPoint
                }
            }
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touches.count > 0){
            if let touch = touches.first{
                let touchPoint=touch.locationInNode(centeredNode)
                if prevTouch != nil{
                    if !(prevTouch!.checkTouch(touch)){//moved out of button
                        timer.removeAllActions()
                    }
                }
                if prevPoint != nil{
                    let d=MathHelper.displacement(prevPoint!, p1: touchPoint)
                    dragVelocity=d.dy
                    characterButtonGroup.runAction(SKAction.moveToY(prevPoint!.y+d.dy, duration: 0))
                }
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        timer.removeAllActions()
        if (touches.count > 0){
            if let touch = touches.first{
                //let touchPoint=touch.locationInNode(centeredNode)
                if (prevTouch!.checkTouch(touch)){
                    //prevTouch!.click()
                    //click(prevTouch!)
                }
            }
        }
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        prevTouch=nil
        timer.removeAllActions()
    }
    func onHold(){
        let cs=CharacterSlot(x: 0,y: 300,character: nil)
        characterButtonGroup.addChild(cs)
        //prevTouch!.hold()
        if(prevTouch?.getClass()=="CharacterButton"){
            viewController?.showCharScene((prevTouch! as! CharacterButton).character)
        }
        else if (prevTouch?.getClass()=="CharacterSlot"){
            viewController?.showCharScene((prevTouch! as! CharacterSlot).character!)
        }
    }
    override func update(currentTime: CFTimeInterval) {
        if abs(dragVelocity)>0{
            characterButtonGroup.runAction(SKAction.moveToY(prevPoint!.y+dragVelocity, duration: 0))
            dragVelocity *= 0.9
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}