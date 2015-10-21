//
//  TeamScene.swift
//  WaveAttack
//
//  Created by James on 19/10/15.
//
//

import Foundation
import SpriteKit

class TeamScene: SKScene{
    
    override init() {
        super.init()
        size=CGSize(width: 300, height: 300)
        
        var buttonX = -200
        var buttonY = 0
        for c in CharacterManager.characters!{
            //make buttons
            
            //displace next button
            buttonX += 100
            if (buttonX == 300){
                buttonX = -200
                buttonY += 100
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}