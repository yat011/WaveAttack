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
        
        frameNode=SKShapeNode(rect: CGRect(origin: CGPoint(x: -20,y: -20), size: CGSize(width: 40,height: 40)), cornerRadius: 5)
        
        super.init(size: size, viewController: viewController)
        selfScene=GameViewController.Scene.TeamScene
        
        self.addChild(centeredNode)
        var buttonX = -120
        var buttonY = 0
        //centeredNode.addChild(clickNodes)
        self.addChild(timer)
        centeredNode.addChild(characterButtonGroup)
        
        
        var ownedCharacters = PlayerInfo.getAllOwnedCharacter()
        for c in ownedCharacters{
            //make buttons
            var character = CharacterManager.getCharacterByID(c.characterId!.integerValue)
            let cb=CharacterButton(x: buttonX,y: buttonY,character: character!, owned: c)
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
        for i in 0..<5{
            //make slots
            
            let cs=CharacterSlot(x: -120+60*i,y: 600, slot:i)
            cs.name="CharacterSlot"
            centeredNode.addChild(cs)
            interactables.append(cs)
        }
        self.backgroundColor=UIColor.darkGrayColor()
        let backButton=BackButton(texture: nil, size: CGSize(width: 60, height: 30))
        backButton.position=CGPoint(x:30, y:viewController.screenSize.height-20)
        backButton.color=UIColor.redColor()
        interactables.append(backButton)
        self.addChild(backButton)
        // team border
        let teamBorder = SKSpriteNode(imageNamed: "teamBorder")
        teamBorder.size = CGSize(width: 310, height: 50)
        teamBorder.position = CGPoint(x: 30, y: 600)
        teamBorder.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        self.addChild(teamBorder)
        
        
    }
    
    var selected:Interactable?=nil
    var frameNode:SKShapeNode
    override func onClick(){
        if(prevTouch?.getClass()=="BackButton"){
            touchable=false
            prevTouch!.onClick()
            return
        }
        if(prevTouch?.getClass()=="CharacterSlot"){
            if (selected != nil){
                frameNode.removeFromParent()
            }
            if state==states.none{
                selected=prevTouch
                state=states.selectedSlot
            }
            else if state==states.selectedButton{   //button-slot
                
                let slot = (prevTouch! as! CharacterSlot)
                let btn = (selected! as! CharacterButton)
                if  PlayerInfo.checkInTeam(btn.ownedCharacter!) == false{
                    PlayerInfo.changeTeamCharacter(slot.slot, character: btn.ownedCharacter!)
                    
                    (prevTouch! as! CharacterSlot).character = (selected! as! CharacterButton).character
                    (prevTouch! as! CharacterSlot).updateGraphics()
                    (PlayerInfo.playerInfo!.teams!.allObjects[0] as! Team)
                    selected=nil
                    
                }else{
                    print("using")
                }
                state=states.none
            }
            else if state==states.selectedSlot{     //slot-slot
                if (selected! as! CharacterSlot) === (prevTouch! as! CharacterSlot) {       //cancel select
                    
                    let slot = (selected! as! CharacterSlot)
                    PlayerInfo.changeTeamCharacter(slot.slot, character: nil)
                    (selected! as! CharacterSlot).character=nil
                    (selected! as! CharacterSlot).updateGraphics()
                    selected=nil
                }
                else{ // swap
                    let prevSlot = (prevTouch! as! CharacterSlot)
                    let selectedSlot = (selected! as! CharacterSlot)
                    
                    let tempChar = (prevTouch! as! CharacterSlot).character
                    (prevTouch! as! CharacterSlot).character = (selected! as! CharacterSlot).character
                    (selected! as! CharacterSlot).character = tempChar
                    
                    let prevOwned = PlayerInfo.getCharacterAt(prevSlot.slot)
                    let currentOwned = PlayerInfo.getCharacterAt(selectedSlot.slot)
                    PlayerInfo.changeTeamCharacter(prevSlot.slot, character: currentOwned)
                    PlayerInfo.changeTeamCharacter(selectedSlot.slot, character: prevOwned)
                    
                    (prevTouch! as! CharacterSlot).updateGraphics()
                    (selected! as! CharacterSlot).updateGraphics()
                    selected=nil
                }
                state=states.none
            }
            if (selected != nil){
                (selected as! SKSpriteNode).addChild(frameNode)
            }
        }
        else if(prevTouch?.getClass()=="CharacterButton"){
            if (selected != nil){
                frameNode.removeFromParent()
            }
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
                let slot = (selected! as! CharacterSlot)
                let btn = (prevTouch! as! CharacterButton)
                if  PlayerInfo.checkInTeam(btn.ownedCharacter!) == false{
                    PlayerInfo.changeTeamCharacter(slot.slot, character: btn.ownedCharacter!)
                
               //     (PlayerInfo.playerInfo!.teams!.allObjects[0] as! Team)
                    (selected! as! CharacterSlot).character = (prevTouch! as! CharacterButton).character
                    (selected! as! CharacterSlot).updateGraphics()
                   // state=states.none
                    selected=nil

                }else{
                    print("using")
                }
                state=states.none
                
            }
            if (selected != nil){
                (selected as! SKSpriteNode).addChild(frameNode)
            }
        }
        PlayerInfo.save()
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
        }
        else if (prevTouch?.getClass()=="CharacterSlot"){
            if ((prevTouch! as! CharacterSlot).character != nil){
                touchable=false
                prevTouch!.onHold()
            }
        }
    }
    
    
    func moveCharacterButtonGroupTo(var newY:CGFloat){
        if newY>500{
            newY=500
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