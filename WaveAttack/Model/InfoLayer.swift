//
//  InfoLayer.swift
//  WaveAttack
//
//  Created by yat on 29/9/2015.
//
//

import Foundation
import SpriteKit

class InfoLayer : SKNode{
    
    
    var player : Player
    var hpBar : HpBar? = nil
    
    init(position : CGPoint, player: Player){
        self.player = player
        super.init()
        self.position = position
        self.zPosition = 1002
        var barSize = CGSize(width: 200, height: 15)
        var hpPos = CGPoint(x: 5, y: 10)
        
        hpBar = HpBar.createHpBar( CGRect(origin: hpPos, size: barSize) , max: player.oriHp, current: player.hp, belongTo : player)
        self.addChild(hpBar!)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
        hpBar!.updateCurrentHp(player.hp)
    }
    
    
}