//
//  GameViewController.swift
//  WaveAttack
//
//  Created by yat on 11/9/2015.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var prevScene:[Scene] = []
    static weak var current: GameViewController? = nil
    static var currentMissionId = 1
    static weak var skView :SKView? = nil
    static weak var currentScene : SKScene? = nil
    enum Scene{
        case None
        case MenuScene
        case OptionScene
        case MissionScene
        case GameScene
        case TeamScene
        case CharScene
    }
    
    let fixedFps : Int = 30

    let screenSize:CGSize=CGSize(width: 375, height: 667)

 
    override func viewDidLoad() {
        super.viewDidLoad()

       
            // Configure the view.
            let skView = self.view as! SKView
            GameViewController.skView = skView
        
            skView.showsFPS = true
            skView.showsNodeCount = true
           //skView.showsPhysics = true
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            skView.frameInterval = 60 / fixedFps
         //   let scene = GameScene(size: screenSize, missionId: GameViewController.currentMissionId, viewController: self)
        
        
        /* if let scene = GameScene(fileNamed : "GameScene"){
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
        }
        */
       // scene.scaleMode = .AspectFit

        //scene.viewController=self

        
        GameViewController.current = self
        
       
        
        skView.presentScene(MainMenu(size: self.screenSize, viewController: self))
       // skView.
        //print(skView.bounds.size)
        
    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    

    func sceneTransition(scene:SKScene, transition:SKTransition){
        let skView = self.view as! SKView
        skView.presentScene(scene, transition:transition)
    }
    
    func sceneTransitionForward(selfScene:Scene, nextScene:Scene){
        let transition=SKTransition.fadeWithDuration(2)
        sceneTransitionForward(selfScene, nextScene:nextScene, transition:transition)
    }
    func sceneTransitionForward(selfScene:Scene, nextScene:Scene, transition:SKTransition){
        prevScene.append(selfScene)
     
        switch nextScene {
        case .TeamScene:
            sceneTransition(TeamScene(size: screenSize, viewController: self), transition:transition)
            break
        case .GameScene:
            sceneTransition(GameScene(size: screenSize,missionId: GameViewController.currentMissionId, viewController: self), transition:transition)
            break
        case .MenuScene:
            sceneTransition(MainMenu(size: screenSize, viewController: self), transition:transition)
            break
        case .MissionScene:
            sceneTransition(MissionScene(size: screenSize, viewController: self), transition: transition)
        default:
            break
        }
    }
    
    func sceneTransitionBackward(){
        let transition=SKTransition.fadeWithDuration(2)
        sceneTransitionBackward(transition)
    }
    func sceneTransitionBackward(transition:SKTransition){
        let prev=prevScene.removeLast()
        switch prev {
        case .TeamScene:
            sceneTransition(TeamScene(size: screenSize, viewController: self), transition:transition)
            break
        case .GameScene:
            break
        case .MenuScene:
            sceneTransition(MainMenu(size: screenSize, viewController: self), transition:transition)
            break
        case .MissionScene:
            sceneTransition(MissionScene(size: screenSize, viewController: self), transition: transition)
        default:
            break
        }
        
    }
    
    func sceneTransitionSK(selfScene:Scene, nextScene:SKScene){
        let transition=SKTransition.fadeWithDuration(5)
        sceneTransitionSK(selfScene, nextScene:nextScene, transition:transition)
    }
    func sceneTransitionSK(selfScene:Scene, nextScene:SKScene, transition:SKTransition){
        prevScene.append(selfScene)
        let transition=SKTransition.fadeWithDuration(5)
        sceneTransition(nextScene, transition:transition)
    }
    
    
    
    
/*
    func changeScene(nextScene:Scene){
        let transition=SKTransition.fadeWithDuration(5)
        changeScene([Scene](), nextScene: nextScene, transition: transition)
    }
    func changeScene(prevScene:[Scene], nextScene:Scene){
    //func changeScene(prevScene:Scene, nextScene:Scene){
        let transition=SKTransition.fadeWithDuration(5)
        changeScene(prevScene, nextScene: nextScene, transition: transition)
    }
    func changeScene(prevScene:[Scene], nextScene:Scene, transition:SKTransition){
    //func changeScene(prevScene:Scene, nextScene:Scene, transition:SKTransition){
        let skView = self.view as! SKView
        var tempScene:SKScene
        if (nextScene == Scene.TeamScene){
            tempScene=TeamScene(size: screenSize, viewController: self, prevScene: prevScene)
            skView.presentScene(tempScene,transition: transition)
        }
        else if (nextScene == Scene.GameScene){
            tempScene=GameScene(size: screenSize, viewController: self, prevScene: prevScene)
            skView.presentScene(tempScene,transition: transition)
        }
    }
    func showCharScene(prevScene:[Scene], c:Character){
        let skView = self.view as! SKView
        let t=SKTransition.fadeWithDuration(5)
        let tempScene:CharScene
        tempScene=CharScene(size: screenSize, viewController: self, prevScene:prevScene)
        skView.presentScene(tempScene,transition: t)
    }
*/
}
