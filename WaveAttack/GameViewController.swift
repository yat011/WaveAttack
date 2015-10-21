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
        case MenuScene
        case OptionScene
        case MissionScene
        case GameScene
        case TeamScene
    }
    
    let fixedFps : Int = 30
    static weak var current: GameViewController? = nil
    static var currentMissionId = 1
    static var skView :SKView? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

       
            // Configure the view.
            let skView = self.view as! SKView
            GameViewController.skView = skView
            skView.showsFPS = true
            skView.showsNodeCount = true
          //  skView.showsPhysics = true
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            skView.frameInterval = 60 / fixedFps
        let scene = GameScene(size: CGSize(width: 375, height: 667), missionId: GameViewController.currentMissionId)
        
        
           /* if let scene = GameScene(fileNamed : "GameScene"){
            /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
            
                skView.presentScene(scene)
            }
        */
        scene.scaleMode = .AspectFit
        scene.viewController=self

        
       GameViewController.current = self
        print(skView.scene)

        skView.presentScene(scene)
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
    
    func changeScene(s:Scene){
        let skView = self.view as! SKView
        let t=SKTransition.fadeWithDuration(5)
        let tempScene:SKScene
        if (s == Scene.TeamScene){
            tempScene=TeamScene()
            skView.presentScene(tempScene,transition: t)
        }
    }
}
