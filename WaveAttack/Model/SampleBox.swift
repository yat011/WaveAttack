//
//  SampleBox.swift
//  WaveAttack
//
//  Created by yat on 14/9/2015.
//
//

import Foundation
import SpriteKit

class SampleBox : DestructibleObject {
    
    var sprite : GameSKSpriteNode? = GameSKSpriteNode(imageNamed: "box")
    override var xDivMax :CGFloat { get{ return 255}}
    override var yDivMax :CGFloat { get{ return 255}}
    
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {

        super.initialize(size, position: position, gameScene: gameScene)
        
        self.propagationSpeed = 3.2
        
        self.collisionAbsorption = 50
 
      
        
    }
    
    
    override func drawPath(path: CGMutablePath, offsetX : CGFloat, offsetY: CGFloat) {
        PathMoveToPoint(path, nil, 0 - offsetX, 255 - offsetY);
        PathAddLineToPoint(path, nil, 255 - offsetX, 255 - offsetY);
        PathAddLineToPoint(path, nil, 255 - offsetX, 0 - offsetY);
        PathAddLineToPoint(path, nil, -0 - offsetX, 0 - offsetY);
    }
    
    
    
    
    
    override func getSprite() -> SKNode? {
        return sprite
    }
    
    
}