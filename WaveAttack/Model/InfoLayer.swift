//
//  InfoLayer.swift
//  WaveAttack
//
//  Created by yat on 29/9/2015.
//
//

import Foundation
import SpriteKit

class InfoLayer : SKNode , Clickable{
    
    
    var player : Player
    var hpBar : HpBar? = nil
    var menu : ButtonUI? = nil
    weak var gameScene :GameScene? = nil
    var confirmWindow : ConfirmWindow? = nil
    init(position : CGPoint, player: Player, gameScene: GameScene){
        self.player = player
        super.init()
        self.position = position
        self.zPosition = 1002
        var barSize = CGSize(width: 200, height: 15)
        var hpPos = CGPoint(x: 110, y:12)
        
        hpBar = HpBar.createHpBar( CGRect(origin: hpPos, size: barSize) , max: player.oriHp, current: player.hp, belongTo : player)
        self.addChild(hpBar!)
        hpBar!.label!.hidden = false
        menu = ButtonUI.createButton(CGRect(x: 340, y: 10, width: 50 , height: 25), text: "Menu", onClick: {
            () -> () in
            print("click")
            let yesFunc = {
                () -> () in
               gameScene.BackToMenu()
                
            }
            let noFunc = {
                () -> () in
                self.confirmWindow?.hidden = true
                self.gameScene!.resumeStage()
                
            }
            
            if (self.confirmWindow == nil){
                self.confirmWindow = ConfirmWindow.createConfirmUI(CGRect(x : gameScene.size.width / 2, y: gameScene.size.height/2, width: 250, height: 175) , yesFunc: yesFunc, noFunc: noFunc, gameScene: gameScene)
            //self.confirmWindow?.zPosition = 1000000
            
                gameScene.addChild(self.confirmWindow!)
            }else{
                self.confirmWindow!.hidden = false
            }
            gameScene.currentStage = GameStage.Pause
            
            
            //let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            //var mainmenu = storyBoard.instantiateViewControllerWithIdentifier("MainMenu")
            //gameScene.removeAllChildren()
            //gameScene.removeFromParent()
            //(GameViewController.current!.view as! SKView).presentScene(nil)
            /*
            GameViewController.current?.dismissViewControllerAnimated(true, completion: {
                () -> () in
             //   GameViewController.current?.presentViewController(mainmenu, animated: false, completion: nil)
            })*/
            //var menu = MainMenuController()
           

            
        }, gameScene: gameScene )
        self.gameScene = gameScene
        self.gameScene?.addClickable(GameStage.Superposition, self.menu!)
        self.addChild(menu!)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
        hpBar!.updateCurrentHp(player.hp)
    }
    
    
    func getRect() -> CGRect {
        //print (self.frame)
        return CGRect(origin: self.frame.origin, size: CGSize(width: gameScene!.size.width, height: 50))
    }
    
    func checkClick(touchPoint: CGPoint) -> Clickable? {
        //print(getRect())
        if (CGRectContainsPoint(getRect(), touchPoint)){
            return menu!.checkClick(touchPoint)
        }else {
            return nil
        }
    }
    func click() {
        
    }
    
    
}