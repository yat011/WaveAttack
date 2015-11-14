//
//  ConvexLen.swift
//  WaveAttack
//
//  Created by yat on 4/10/2015.
//
//

import Foundation
import SpriteKit
class ConvexLen: DestructibleObject{
    override var xDivMax :CGFloat { get{ return 1285}}
    override var yDivMax :CGFloat { get{ return 742}}
    var _sprite = GameSKSpriteNode(imageNamed: "Oval")
    
    override func getSprite() -> SKNode? {
        return sprite
    }
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
        
        super.initialize(size, position: position, gameScene: gameScene)
        self._sprite.physicsBody!.dynamic = false
        self._sprite.physicsBody!.categoryBitMask = 0
        self._sprite.physicsBody!.collisionBitMask = 0
        self.propagationSpeed = 2.5
        
        self.collisionAbsorption = 50
        
        self.absorptionRate = 0.001
        self.damageReduction = 0
        
    }
    
    
    
    override func drawPath(path: CGMutablePath, offsetX: CGFloat, offsetY: CGFloat) {
        PathMoveToPoint(path, nil, 366 - offsetX, 706 - offsetY);
        PathAddLineToPoint(path, nil, 226 - offsetX, 653 - offsetY);
        PathAddLineToPoint(path, nil, 120 - offsetX, 586 - offsetY);
        PathAddLineToPoint(path, nil, 68 - offsetX, 537 - offsetY);
        PathAddLineToPoint(path, nil, 35 - offsetX, 496 - offsetY);
        PathAddLineToPoint(path, nil, 12 - offsetX, 447 - offsetY);
        PathAddLineToPoint(path, nil, 1 - offsetX, 408 - offsetY);
        PathAddLineToPoint(path, nil, 0 - offsetX, 396 - offsetY);
        PathAddLineToPoint(path, nil, -1 - offsetX, 342 - offsetY);
        PathAddLineToPoint(path, nil, 12 - offsetX, 285 - offsetY);
        PathAddLineToPoint(path, nil, 57 - offsetX, 218 - offsetY);
        PathAddLineToPoint(path, nil, 137 - offsetX, 139 - offsetY);
        PathAddLineToPoint(path, nil, 222 - offsetX, 90 - offsetY);
        PathAddLineToPoint(path, nil, 299 - offsetX, 56 - offsetY);
        PathAddLineToPoint(path, nil, 377 - offsetX, 33 - offsetY);
        PathAddLineToPoint(path, nil, 463 - offsetX, 13 - offsetY);
        PathAddLineToPoint(path, nil, 559 - offsetX, 2 - offsetY);
        PathAddLineToPoint(path, nil, 587 - offsetX, 0 - offsetY);
        PathAddLineToPoint(path, nil, 694 - offsetX, 0 - offsetY);
        PathAddLineToPoint(path, nil, 773 - offsetX, 7 - offsetY);
        PathAddLineToPoint(path, nil, 860 - offsetX, 20 - offsetY);
        PathAddLineToPoint(path, nil, 942 - offsetX, 41 - offsetY);
        PathAddLineToPoint(path, nil, 1035 - offsetX, 76 - offsetY);
        PathAddLineToPoint(path, nil, 1109 - offsetX, 113 - offsetY);
        PathAddLineToPoint(path, nil, 1167 - offsetX, 154 - offsetY);
        PathAddLineToPoint(path, nil, 1201 - offsetX, 182 - offsetY);
        PathAddLineToPoint(path, nil, 1240 - offsetX, 228 - offsetY);
        PathAddLineToPoint(path, nil, 1267 - offsetX, 274 - offsetY);
        PathAddLineToPoint(path, nil, 1286 - offsetX, 336 - offsetY);
        PathAddLineToPoint(path, nil, 1286 - offsetX, 389 - offsetY);
        PathAddLineToPoint(path, nil, 1284 - offsetX, 417 - offsetY);
        PathAddLineToPoint(path, nil, 1261 - offsetX, 478 - offsetY);
        PathAddLineToPoint(path, nil, 1219 - offsetX, 538 - offsetY);
        PathAddLineToPoint(path, nil, 1153 - offsetX, 598 - offsetY);
        PathAddLineToPoint(path, nil, 1079 - offsetX, 643 - offsetY);
        PathAddLineToPoint(path, nil, 982 - offsetX, 686 - offsetY);
        PathAddLineToPoint(path, nil, 882 - offsetX, 716 - offsetY);
        PathAddLineToPoint(path, nil, 820 - offsetX, 729 - offsetY);
        PathAddLineToPoint(path, nil, 737 - offsetX, 738 - offsetY);
        PathAddLineToPoint(path, nil, 677 - offsetX, 741 - offsetY);
        PathAddLineToPoint(path, nil, 612 - offsetX, 741 - offsetY);
        PathAddLineToPoint(path, nil, 511 - offsetX, 735 - offsetY);
    }
    
    
}