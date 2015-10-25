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
        
        let skView = self.view as! SKView
        // Configure the view.
        skView.showsFPS = true
        skView.showsNodeCount = true
        //  skView.showsPhysics = true
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        skView.frameInterval = 60 / fixedFps
        let scene = GameScene(size: screenSize)
        
        
        /* if let scene = GameScene(fileNamed : "GameScene"){
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
        }
        */
        scene.scaleMode = .AspectFit
        scene.viewController=self
        skView.presentScene(scene)
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
        let tempScene:SKScene
        if (nextScene == Scene.TeamScene){
            tempScene=TeamScene(size: screenSize, viewController: self, prevScene: prevScene)
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
}
