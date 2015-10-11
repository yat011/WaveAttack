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
    init(position : CGPoint, player: Player, gameScene: GameScene){
        self.player = player
        super.init()
        self.position = position
        self.zPosition = 1002
        var barSize = CGSize(width: 200, height: 15)
        var hpPos = CGPoint(x: 5, y: 10)
        
        hpBar = HpBar.createHpBar( CGRect(origin: hpPos, size: barSize) , max: player.oriHp, current: player.hp, belongTo : player)
        self.addChild(hpBar!)
        
        menu = ButtonUI.createButton(CGRect(x: 340, y: 10, width: 50 , height: 25), text: "Menu", onClick: {
            () -> () in
            print("click")
        }, gameScene: gameScene )
        self.gameScene = gameScene
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