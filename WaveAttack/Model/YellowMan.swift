//
//  Snail.swift
//  WaveAttack
//
//  Created by yat on 2/10/2015.
//
//

import Foundation
import SpriteKit

class YellowMan : DestructibleObject , EnemyActable{
    typealias finishCallBack = ()->()
    
    
    var action : EnemyAction? = nil
    var Action : EnemyAction { get { return action!}}
    var sprite : GameSKSpriteNode? = GameSKSpriteNode(imageNamed: "YellowMonster")
    override var xDivMax :CGFloat { get{ return 400}}
    override var yDivMax :CGFloat { get{ return 400}}
    
    override func getSprite() -> SKNode? {
        return sprite
    }
    
    
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
        
        super.initialize(size, position: position, gameScene: gameScene)
        //TextureTools.getPixelColorAtLocationArray((UIImage(named: "YellowMonster")?.CGImage)!)
        action = DirectAttack()
        action!.initialize(self)
        (action as! DirectAttack).damage = 200
        moveRound = 2
        self.triggerEvent(GameEvent.RoundChanged.rawValue)
        sprite!.name = "YellowMan"
        sprite!.gameObject = self
        self.propagationSpeed = 1.5
        self.collisionAbsorption = 10
        self.absorptionRate = 0.08
      //  print("mass \(self.getSprite()!.physicsBody!.mass)")
        self.getSprite()!.physicsBody!.density = 0.7
       // print("mass \(self.getSprite()!.physicsBody!.mass)")
        
    }
    
    
    
    override func drawPath(path: CGMutablePath, offsetX: CGFloat, offsetY: CGFloat) {
        
        PathMoveToPoint(path, nil, 195 - offsetX, 399 - offsetY);
        PathAddLineToPoint(path, nil, 152 - offsetX, 394 - offsetY);
        PathAddLineToPoint(path, nil, 131 - offsetX, 387 - offsetY);
        PathAddLineToPoint(path, nil, 103 - offsetX, 375 - offsetY);
        PathAddLineToPoint(path, nil, 79 - offsetX, 359 - offsetY);
        PathAddLineToPoint(path, nil, 58 - offsetX, 342 - offsetY);
        PathAddLineToPoint(path, nil, 45 - offsetX, 327 - offsetY);
        PathAddLineToPoint(path, nil, 26 - offsetX, 299 - offsetY);
        PathAddLineToPoint(path, nil, 14 - offsetX, 276 - offsetY);
        PathAddLineToPoint(path, nil, 8 - offsetX, 257 - offsetY);
        PathAddLineToPoint(path, nil, 3 - offsetX, 240 - offsetY);
        PathAddLineToPoint(path, nil, 0 - offsetX, 224 - offsetY);
        PathAddLineToPoint(path, nil, 0 - offsetX, 218 - offsetY);
        PathAddLineToPoint(path, nil, 0 - offsetX, 179 - offsetY);
        PathAddLineToPoint(path, nil, 4 - offsetX, 153 - offsetY);
        PathAddLineToPoint(path, nil, 9 - offsetX, 135 - offsetY);
        PathAddLineToPoint(path, nil, 20 - offsetX, 112 - offsetY);
        PathAddLineToPoint(path, nil, 47 - offsetX, 70 - offsetY);
        PathAddLineToPoint(path, nil, 57 - offsetX, 59 - offsetY);
        PathAddLineToPoint(path, nil, 78 - offsetX, 41 - offsetY);
        PathAddLineToPoint(path, nil, 99 - offsetX, 26 - offsetY);
        PathAddLineToPoint(path, nil, 122 - offsetX, 14 - offsetY);
        PathAddLineToPoint(path, nil, 151 - offsetX, 5 - offsetY);
        PathAddLineToPoint(path, nil, 177 - offsetX, 1 - offsetY);
        PathAddLineToPoint(path, nil, 200 - offsetX, 0 - offsetY);
        PathAddLineToPoint(path, nil, 231 - offsetX, 2 - offsetY);
        PathAddLineToPoint(path, nil, 261 - offsetX, 9 - offsetY);
        PathAddLineToPoint(path, nil, 292 - offsetX, 21 - offsetY);
        PathAddLineToPoint(path, nil, 320 - offsetX, 39 - offsetY);
        PathAddLineToPoint(path, nil, 347 - offsetX, 63 - offsetY);
        PathAddLineToPoint(path, nil, 370 - offsetX, 91 - offsetY);
        PathAddLineToPoint(path, nil, 386 - offsetX, 121 - offsetY);
        PathAddLineToPoint(path, nil, 398 - offsetX, 166 - offsetY);
        PathAddLineToPoint(path, nil, 399 - offsetX, 207 - offsetY);
        PathAddLineToPoint(path, nil, 396 - offsetX, 241 - offsetY);
        PathAddLineToPoint(path, nil, 389 - offsetX, 271 - offsetY);
        PathAddLineToPoint(path, nil, 370 - offsetX, 308 - offsetY);
        PathAddLineToPoint(path, nil, 354 - offsetX, 328 - offsetY);
        PathAddLineToPoint(path, nil, 327 - offsetX, 355 - offsetY);
        PathAddLineToPoint(path, nil, 295 - offsetX, 377 - offsetY);
        PathAddLineToPoint(path, nil, 259 - offsetX, 390 - offsetY);
        PathAddLineToPoint(path, nil, 227 - offsetX, 398 - offsetY);
    }
    
    
    
    
    
    
}