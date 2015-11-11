//
//  MainMenu.swift
//  WaveAttack
//
//  Created by yat on 27/10/2015.
//
//

import Foundation
import SpriteKit
import UIKit
class MainMenu : TransitableScene{
    
    
    
    override init(size: CGSize, viewController: GameViewController) {
        super.init(size: size, viewController: viewController)
        self.selfScene = GameViewController.Scene.MenuScene
        
        var missionBtn = ButtonUI.createButton(CGRect(origin: CGPoint(x: viewController.screenSize.width/2, y: 500) , size: CGSize(width: 100, height: 50)), text: "Missions", onClick: {
            ()->() in
                //GameViewController.currentMissionId = 1
                self.changeScene(GameViewController.Scene.MissionScene)
            
            }, gameScene: nil)
        var teamBtns = ButtonUI.createButton(CGRect(origin: CGPoint(x: viewController.screenSize.width/2, y: 400) , size: CGSize(width: 100, height: 50)), text: "Team", onClick: {
            ()->() in
           // GameViewController.currentMissionId = 1
            self.changeScene(GameViewController.Scene.TeamScene)
            
            }, gameScene: nil)
        
        var exit = ButtonUI.createButton(CGRect(origin: CGPoint(x: viewController.screenSize.width/2, y: 100) , size: CGSize(width: 100, height: 50)), text: "Exit", onClick: {
            ()->() in
            // GameViewController.currentMissionId = 1
            //self.changeScene(GameViewController.Scene.TeamScene)
        //        exit()
            
            }, gameScene: nil)
        
        var back = SKSpriteNode(imageNamed: "mainBack")
        back.anchorPoint = CGPoint()
        back.size = self.viewController!.screenSize
        back.zPosition = -100
        
        self.addChild(back)
       // self.addChild(exit)
        self.addChild(teamBtns)
        self.addChild(missionBtn)
        self.interactables.append(missionBtn)
        self.interactables.append(teamBtns)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}