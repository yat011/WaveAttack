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
    var scoreLabel : ScoreLabel? = nil
    var announcement =  AnnouncementUI()
    var skillIcon = [SKSpriteNode]()
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
            
            
            
           

            
        }, gameScene: gameScene )
        self.gameScene = gameScene
        self.gameScene?.addClickable(GameStage.Superposition, self.menu!)
        self.addChild(menu!)
        
       self.scoreLabel = ScoreLabel(position: CGPoint(x: 305, y: 5))
        self.addChild(self.scoreLabel!)
        announcement.position = CGPoint(x: GameScene.current!.size.width/2, y: -20)
        self.addChild(announcement)
        
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
    
    func addSkillIcon (node: SKSpriteNode){
       skillIcon.append(node)
        node.size = CGSize(width: 40, height: 40)
       reDrawSkillIcon()
    }
    func removeSkillIcon (node : SKSpriteNode){
        skillIcon.removeObject(node)
        node.removeFromParent()
        reDrawSkillIcon()
    }
    func reDrawSkillIcon(){
        
        for var i = 0 ; i < skillIcon.count ; i++ {
            skillIcon[i].removeFromParent()
           skillIcon[i].position = CGPoint(x: 30 + 45 * i, y: -20)
            self.addChild(skillIcon[i])
            
        }
        
    }
    
}