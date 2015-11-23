//
//  MissionScene.swift
//  WaveAttack
//
//  Created by yat on 27/10/2015.
//
//

import Foundation
import SpriteKit


class MissionScene: TransitableScene{
    
    override init(size: CGSize, viewController: GameViewController) {
        super.init(size: size, viewController: viewController)
        self.selfScene = GameViewController.Scene.MissionScene
        
        var backBtn = ButtonUI.createButton(CGRect(origin: CGPoint(x: 30, y: 600) , size: CGSize(width: 50, height: 50)), text: "Back", onClick: {
            ()->() in
            self.viewController!.sceneTransitionBackward()
            
            }, gameScene: nil)
        self.addChild(backBtn)
        interactables.append(backBtn)
        
       
        
        var info = PlayerInfo.playerInfo
        var numDisplay = info!.passMission!.integerValue + 1
        if (numDisplay > Mission.missionList.count){
            numDisplay = Mission.missionList.count
        }
        var missionBtns = [ButtonUI]()
        var lowest:CGFloat = 0
        var posIndex = 0
        for var i = numDisplay  ; i > 0 ; i-- {
            lowest = 200 - CGFloat(posIndex) * 100
            var missionBtn : MissionButton? = nil
            var btnText:String = ""
        
            var missionData = PlayerInfo.getPassedMissionById(i)
            if missionData == nil{
                btnText = Mission.missionList[i]!
            }else{
                btnText = String(format: "%@ (%.0f)", Mission.missionList[i]!, missionData!.score!.floatValue)
                
            }
            
            
            missionBtn = MissionButton(rect: CGRect(origin: CGPoint(x: 0, y: lowest) , size: CGSize(width: 150, height: 50)), text: btnText, onClick: {
                ()->() in
                    if PlayerInfo.team.characters?.count != 5 {
                        self.createFlashLabel("You mush use 5 pets")
                        return
                    }
                    GameViewController.currentMissionId = missionBtn!.missionId
                    self.changeScene(GameViewController.Scene.GameScene)
                }, gameScene: nil)
            missionBtn!.missionId = i
            missionBtns.append(missionBtn!)
            posIndex++
            
            
        }
        lowest -= 30
        var upper:CGFloat = lowest + 250
        if (upper > 0){
            upper = 0
        }else{
            upper = abs(upper)
        }
        
        var draggNode = VerticalDraggableNode.createNode(CGPoint(x: viewController.screenSize.width/2,y: 300), size: CGSize(width: 300, height: 500), lowerBound:0, upperBound:upper )
        for var i in missionBtns{
            draggNode.content.addChild(i)
            interactables.append(i)
        }
        var back = SKSpriteNode(imageNamed: "menuBack")
        back.anchorPoint = CGPoint()
        back.size = self.viewController!.screenSize
        back.zPosition = -100
        self.addChild(back)
        self.addChild(draggNode)
        self.draggables.append(draggNode)
        
        
    }
    func createFlashLabel(text : String){
        let label = SKLabelNode(text: text)
        label.position = CGPoint(x: self.size.width / 2, y: 500)
        label.zPosition = 10000
        label.fontName = "Helvetica"
        label.fontSize = 20
        label.verticalAlignmentMode = .Center
        let back = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 200, height: 80))
        back.alpha = 0.8
        back.zPosition = -1
        label.addChild(back)
        let seq : [SKAction] = [SKAction.waitForDuration(2) , SKAction.fadeOutWithDuration(0.5)]
        
        self.addChild(label)
        label.runAction(SKAction.sequence(seq), completion :
            { () -> () in
                label.removeFromParent()
        })
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}