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
    override var path: CGPath? { get{ return _path}}
    var _path : CGPath? = nil
    init(size : CGSize , position : CGPoint){
    
        super.init()
        if sprite == nil {
            print("sprite == nil")
            exit(1)
        }
        
        self.propagationSpeed = 7
        self.collisionAbsorption = 50
        
        self.sprite!.size = size
        self.sprite!.position = position
        self.sprite!.gameObject = self
        createPhysicsBody(self.sprite!)
    }
    
    private func createPhysicsBody(sprite :  SKSpriteNode){
       // print (sprite.frame.size)
        //print (sprite.anchorPoint)
      //  sprite.anchorPoint.x = 0
       // sprite.anchorPoint.y = 0
        let offsetX:CGFloat = 0
        let offsetY:CGFloat = 0
        self.scaleX = sprite.frame.size.width / 255
        self.scaleY = sprite.frame.size.height / 255
        let path = CGPathCreateMutable();
        
        
        PathMoveToPoint(path, nil, 0 - offsetX, 255 - offsetY);
        PathAddLineToPoint(path, nil, 255 - offsetX, 255 - offsetY);
        PathAddLineToPoint(path, nil, 255 - offsetX, 0 - offsetY);
        PathAddLineToPoint(path, nil, -1 - offsetX, 0 - offsetY);
        
        CGPathCloseSubpath(path);
        _path = path
        //print(CGPathContainsPoint(path, nil,CGPoint(x: 0, y: 0) , true))
        
        let phys = SKPhysicsBody (edgeLoopFromPath: path)
        
        phys.usesPreciseCollisionDetection = true
        phys.collisionBitMask = 0x0
        //phys.affectedByGravity = false
        phys.categoryBitMask = CollisionLayer.Medium.rawValue
        
        sprite.physicsBody = phys
    }
    
    
    
    override func getSprite() -> SKNode? {
        return sprite
    }
    
    
}