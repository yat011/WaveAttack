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
    
    init(size : CGSize , position : CGPoint){
    
        super.init()
        if sprite == nil {
            print("sprite == nil")
            exit(1)
        }
        
        self.propagationSpeed = 70
        
        
        self.sprite!.size = size
        self.sprite!.position = position
        self.sprite!.gameObject = self
        createPhysicsBody(self.sprite!)
    }
    
    private func createPhysicsBody(sprite :  SKSpriteNode){
        print (sprite.frame.size)
        print (sprite.anchorPoint)
        sprite.anchorPoint.x = 0
        sprite.anchorPoint.y = 0
        let offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
        let offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
        self.scaleX = sprite.frame.size.width / 255
        self.scaleY = sprite.frame.size.height / 255
        let path = CGPathCreateMutable();
        
        
        PathMoveToPoint(path, nil, 0 - offsetX, 255 - offsetY);
        PathAddLineToPoint(path, nil, 255 - offsetX, 255 - offsetY);
        PathAddLineToPoint(path, nil, 255 - offsetX, 0 - offsetY);
        PathAddLineToPoint(path, nil, -1 - offsetX, 0 - offsetY);
        
        
        
        CGPathCloseSubpath(path);
        
        let phys = SKPhysicsBody (edgeLoopFromPath: path)
        
        phys.collisionBitMask = 0x0
        //phys.affectedByGravity = false
        phys.categoryBitMask = CollisionLayer.Medium.rawValue
        
        sprite.physicsBody = phys
    }
    
    
    
    override func getSprite() -> SKNode? {
        return sprite
    }
    
    
}