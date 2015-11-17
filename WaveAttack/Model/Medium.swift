//
//  Medium.swift
//  WaveAttack
//
//  Created by yat on 13/9/2015.
//
//

import Foundation
import SpriteKit
class Medium : GameObject {
    
   
    var collisionAbsorption: CGFloat = 0
    
    override init(){
        super.init()
        

    }
    
    init(size : CGSize , position : CGPoint, gameScene :GameScene){
        
        super.init()
        initialize(size, position: position, gameScene: gameScene)
      
    }
    
    func afterAddToScene (){
        
    }
    
   
   
    override func deleteSelf() {
        super.deleteSelf()
    }

   
    func syncPos(){
        
    
        
    }
    
    
    
}