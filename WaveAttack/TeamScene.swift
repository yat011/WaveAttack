//
//  TeamScene.swift
//  WaveAttack
//
//  Created by James on 19/10/15.
//
//

import Foundation
import SpriteKit

class TeamScene: TransitableScene{
    var centeredNode:SKNode
    //var clickNodes:SKNode
    var timer:SKNode
    var characterButtonGroup:SKNode
    var characterButtonGroupRect:CGRect
    override init(size: CGSize, viewController:GameViewController) {
        centeredNode=SKNode()
        centeredNode.position=CGPoint(x: 375/2, y:0)
        timer=SKNode()
        characterButtonGroup=SKNode()
        characterButtonGroupRect=CGRect(origin: CGPoint(x: -375/2, y: 0), size: CGSize(width: 375, height: 500))
        
        super.init(size: size, viewController: viewController)
        selfScene=GameViewController.Scene.TeamScene
        
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
            interactables.append(cb)
        }
        for i in 0..<5{
            //make slots
            let cs=CharacterSlot(x: -120+60*i,y: 600,character: CharacterManager.getCharacterByID(CharacterManager.team[i]))
            cs.name="CharacterSlot"
            centeredNode.addChild(cs)
            interactables.append(cs)
        }
        self.backgroundColor=UIColor.blueColor()
        let backButton=BackButton(texture: nil, size: CGSize(width: 50, height: 50))
        backButton.position=CGPoint(x: 375/2, y: 300)
        backButton.color=UIColor.redColor()
        self.addChild(backButton)
        interactables.append(backButton)
        
    }
    
    
    override func onClick(){
        if(prevTouch?.getClass()=="BackButton"){
            touchable=false
            (prevTouch as! BackButton).click()
        }
        prevTouch=nil
    }
    override func onMove(p0:CGPoint, p1:CGPoint){
        //can use p0,p1 for moving-component check
        let d=MathHelper.displacement(p0, p1: p1)
        dragVelocity=d.dy
        moveCharacterButtonGroupTo(characterButtonGroup.position.y+d.dy)
    }
    override func onHold(){
        //prevTouch!.hold()
        if(prevTouch?.getClass()=="CharacterButton"){
            touchable=false
            viewController.sceneTransitionSK(selfScene, nextScene:CharScene(size: self.size, viewController: viewController))
            //viewController.sceneTransitionSK(prevScene, c: (prevTouch! as! CharacterButton).character)
        }
        else if (prevTouch?.getClass()=="CharacterSlot"){
            touchable=false
            viewController.sceneTransitionSK(selfScene, nextScene:CharScene(size: self.size, viewController: viewController))
            //viewController.showCharScene(prevScene, c: (prevTouch! as! CharacterSlot).character!)
        }
    }
    
    
    func moveCharacterButtonGroupTo(var newY:CGFloat){
        if newY<0{
            newY=0
            dragVelocity=0
        }
        if newY>500{
            newY=500
            dragVelocity=0
        }
        characterButtonGroup.runAction(SKAction.moveToY(newY, duration: 0))
    }
    
    
    var dragVelocity:CGFloat=0
    override func update(currentTime: CFTimeInterval) {
        var tempx: CGFloat = (self.size.width/2)
        if touching==false{
            if abs(dragVelocity)>0{
                moveCharacterButtonGroupTo(characterButtonGroup.position.y+dragVelocity)
                dragVelocity *= 0.9
                if abs(dragVelocity) < 1{
                    dragVelocity=0
                }
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}