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
    enum states:String{
        case none="none"
        case selectedButton="selectedButton"
        case selectedSlot="selectedSlot"
    }
    var state:states=states.none
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
        characterButtonGroupRect=CGRect(origin: CGPoint(x: -375/2, y: viewController.screenSize.height-200), size: CGSize(width: 375, height: 500))
        characterButtonGroup.position=CGPoint(x:0, y:500)
        
        super.init(size: size, viewController: viewController)
        selfScene=GameViewController.Scene.TeamScene
        
        self.addChild(centeredNode)
        var buttonX = -120
        var buttonY = 0
        //centeredNode.addChild(clickNodes)
        self.addChild(timer)
        centeredNode.addChild(characterButtonGroup)
        for c in CharacterManager.characters!{
            //make buttons
            let cb=CharacterButton(x: buttonX,y: buttonY,character: c)
            cb.name="CharacterButton"
            //cb.character=c
            characterButtonGroup.addChild(cb)
            //displace next button
            buttonX += 60
            if (buttonX == 180){
                buttonX = -120
                buttonY -= 100
            }
            interactables.append(cb)
        }
        var characters = (PlayerInfo.playerInfo!.teams!.allObjects[0] as! Team).characters!.allObjects as! [OwnedCharacter]
        for i in 0..<5{
            //make slots
            
            let cs=CharacterSlot(x: -120+60*i,y: 600,character: CharacterManager.getCharacterByID(characters[i].characterId!.integerValue))
            cs.name="CharacterSlot"
            centeredNode.addChild(cs)
            interactables.append(cs)
        }
        self.backgroundColor=UIColor.blueColor()
        let backButton=BackButton(texture: nil, size: CGSize(width: 60, height: 30))
        backButton.position=CGPoint(x:30, y:viewController.screenSize.height-20)
        backButton.color=UIColor.redColor()
        interactables.append(backButton)
        self.addChild(backButton)
    }
    
    var selected:Interactable?=nil
    override func onClick(){
        if(prevTouch?.getClass()=="BackButton"){
            touchable=false
            prevTouch!.onClick()
        }
        else if(prevTouch?.getClass()=="CharacterSlot"){
            if state==states.none{
                selected=prevTouch
                state=states.selectedSlot
            }
            else if state==states.selectedButton{   //button-slot
                (prevTouch! as! CharacterSlot).character = (selected! as! CharacterButton).character
                (prevTouch! as! CharacterSlot).updateGraphics()
                state=states.none
            }
            else if state==states.selectedSlot{     //slot-slot
                if (selected! as! CharacterSlot) === (prevTouch! as! CharacterSlot) {       //cancel select
                    (selected! as! CharacterSlot).character=nil
                    (selected! as! CharacterSlot).updateGraphics()
                    selected=nil
                }
                else{
                    let tempChar = (prevTouch! as! CharacterSlot).character!
                    (prevTouch! as! CharacterSlot).character = (selected! as! CharacterSlot).character!
                    (selected! as! CharacterSlot).character = tempChar
                    (prevTouch! as! CharacterSlot).updateGraphics()
                    (selected! as! CharacterSlot).updateGraphics()
                }
                state=states.none
            }
        }
        else if(prevTouch?.getClass()=="CharacterButton"){
            if state==states.none{
                selected=prevTouch
                state=states.selectedButton
            }
            else if state==states.selectedButton{     //button-button
                if (selected! as! CharacterButton) === (prevTouch! as! CharacterButton) {   //cancel selection
                    selected=nil
                    state=states.none
                }
                else{
                    selected=prevTouch
                    state=states.selectedButton
                }
            }
            else if state==states.selectedSlot{     //slot-button
                (selected! as! CharacterSlot).character = (prevTouch! as! CharacterButton).character
                (selected! as! CharacterSlot).updateGraphics()
                state=states.none
            }
        }
        prevTouch=nil
    }
    override func onDrag(p0:CGPoint, p1:CGPoint){
        //can use p0,p1 for moving-component check
        let d=MathHelper.displacement(p0, p1: p1)
        dragVelocity=d.dy
        moveCharacterButtonGroupTo(characterButtonGroup.position.y+d.dy)
    }
    override func onHold(){
        //prevTouch!.hold()
        if(prevTouch?.getClass()=="CharacterButton"){
            touchable=false

            prevTouch!.onHold()
            //viewController.sceneTransitionSK(selfScene, nextScene:CharScene(size: self.size, viewController: viewController))
            //viewController.sceneTransitionSK(prevScene, c: (prevTouch! as! CharacterButton).character)
        }
        else if (prevTouch?.getClass()=="CharacterSlot"){
            if ((prevTouch! as! CharacterSlot).character != nil){
                touchable=false
                prevTouch!.onHold()
            }
            //viewController.sceneTransitionSK(selfScene, nextScene:CharScene(size: self.size, viewController: viewController))

            //viewController.showCharScene(prevScene, c: (prevTouch! as! CharacterSlot).character!)
        }
    }
    
    
    func moveCharacterButtonGroupTo(var newY:CGFloat){
        if newY>600{
            newY=600
            dragVelocity=0
        }
        if newY<500{
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