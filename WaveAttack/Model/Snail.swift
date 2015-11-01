//
//  Snail.swift
//  WaveAttack
//
//  Created by yat on 2/10/2015.
//
//

import Foundation
import SpriteKit

class Snail : DestructibleObject , EnemyActable{
    typealias finishCallBack = ()->()
    
 
    var action : EnemyAction? = nil
    var Action : EnemyAction { get { return action!}}
    var sprite : GameSKSpriteNode? = GameSKSpriteNode(imageNamed: "Snail")
    override var xDivMax :CGFloat { get{ return 239}}
    override var yDivMax :CGFloat { get{ return 273}}
    
    override func getSprite() -> SKNode? {
        return sprite
    }
    
    
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
     
        super.initialize(size, position: position, gameScene: gameScene)
        action = DirectAttack()
        action!.initialize(self)
        moveRound = 3
        sprite!.name = "Snail"
        sprite!.gameObject = self
        self.propagationSpeed = 2.5
        
        self.collisionAbsorption = 10
        print(physContactSprite.position)
        print(getSprite()!.position)
        
    }
    
  
    
    override func drawPath(path: CGMutablePath, offsetX: CGFloat, offsetY: CGFloat) {
        
        PathMoveToPoint(path, nil, 37 - offsetX, 230 - offsetY);
        PathAddLineToPoint(path, nil, 53 - offsetX, 224 - offsetY);
        PathAddLineToPoint(path, nil, 59 - offsetX, 216 - offsetY);
        PathAddLineToPoint(path, nil, 63 - offsetX, 206 - offsetY);
        PathAddLineToPoint(path, nil, 64 - offsetX, 198 - offsetY);
        PathAddLineToPoint(path, nil, 74 - offsetX, 194 - offsetY);
        PathAddLineToPoint(path, nil, 81 - offsetX, 191 - offsetY);
        PathAddLineToPoint(path, nil, 89 - offsetX, 187 - offsetY);
        PathAddLineToPoint(path, nil, 100 - offsetX, 182 - offsetY);
        PathAddLineToPoint(path, nil, 110 - offsetX, 176 - offsetY);
        PathAddLineToPoint(path, nil, 122 - offsetX, 169 - offsetY);
        PathAddLineToPoint(path, nil, 132 - offsetX, 162 - offsetY);
        PathAddLineToPoint(path, nil, 141 - offsetX, 154 - offsetY);
        PathAddLineToPoint(path, nil, 145 - offsetX, 146 - offsetY);
        PathAddLineToPoint(path, nil, 147 - offsetX, 144 - offsetY);
        PathAddLineToPoint(path, nil, 159 - offsetX, 146 - offsetY);
        PathAddLineToPoint(path, nil, 157 - offsetX, 163 - offsetY);
        PathAddLineToPoint(path, nil, 152 - offsetX, 180 - offsetY);
        PathAddLineToPoint(path, nil, 146 - offsetX, 195 - offsetY);
        PathAddLineToPoint(path, nil, 140 - offsetX, 209 - offsetY);
        PathAddLineToPoint(path, nil, 137 - offsetX, 216 - offsetY);
        PathAddLineToPoint(path, nil, 125 - offsetX, 214 - offsetY);
        PathAddLineToPoint(path, nil, 113 - offsetX, 217 - offsetY);
        PathAddLineToPoint(path, nil, 104 - offsetX, 223 - offsetY);
        PathAddLineToPoint(path, nil, 97 - offsetX, 232 - offsetY);
        PathAddLineToPoint(path, nil, 96 - offsetX, 245 - offsetY);
        PathAddLineToPoint(path, nil, 98 - offsetX, 255 - offsetY);
        PathAddLineToPoint(path, nil, 102 - offsetX, 262 - offsetY);
        PathAddLineToPoint(path, nil, 108 - offsetX, 266 - offsetY);
        PathAddLineToPoint(path, nil, 118 - offsetX, 270 - offsetY);
        PathAddLineToPoint(path, nil, 130 - offsetX, 271 - offsetY);
        PathAddLineToPoint(path, nil, 137 - offsetX, 269 - offsetY);
        PathAddLineToPoint(path, nil, 143 - offsetX, 265 - offsetY);
        PathAddLineToPoint(path, nil, 149 - offsetX, 259 - offsetY);
        PathAddLineToPoint(path, nil, 151 - offsetX, 253 - offsetY);
        PathAddLineToPoint(path, nil, 153 - offsetX, 243 - offsetY);
        PathAddLineToPoint(path, nil, 153 - offsetX, 236 - offsetY);
        PathAddLineToPoint(path, nil, 151 - offsetX, 231 - offsetY);
        PathAddLineToPoint(path, nil, 148 - offsetX, 226 - offsetY);
        PathAddLineToPoint(path, nil, 146 - offsetX, 223 - offsetY);
        PathAddLineToPoint(path, nil, 153 - offsetX, 213 - offsetY);
        PathAddLineToPoint(path, nil, 158 - offsetX, 204 - offsetY);
        PathAddLineToPoint(path, nil, 163 - offsetX, 195 - offsetY);
        PathAddLineToPoint(path, nil, 166 - offsetX, 189 - offsetY);
        PathAddLineToPoint(path, nil, 172 - offsetX, 175 - offsetY);
        PathAddLineToPoint(path, nil, 177 - offsetX, 164 - offsetY);
        PathAddLineToPoint(path, nil, 179 - offsetX, 155 - offsetY);
        PathAddLineToPoint(path, nil, 180 - offsetX, 148 - offsetY);
        PathAddLineToPoint(path, nil, 194 - offsetX, 143 - offsetY);
        PathAddLineToPoint(path, nil, 205 - offsetX, 137 - offsetY);
        PathAddLineToPoint(path, nil, 216 - offsetX, 128 - offsetY);
        PathAddLineToPoint(path, nil, 227 - offsetX, 115 - offsetY);
        PathAddLineToPoint(path, nil, 235 - offsetX, 95 - offsetY);
        PathAddLineToPoint(path, nil, 238 - offsetX, 85 - offsetY);
        PathAddLineToPoint(path, nil, 239 - offsetX, 71 - offsetY);
        PathAddLineToPoint(path, nil, 238 - offsetX, 58 - offsetY);
        PathAddLineToPoint(path, nil, 236 - offsetX, 45 - offsetY);
        PathAddLineToPoint(path, nil, 231 - offsetX, 33 - offsetY);
        PathAddLineToPoint(path, nil, 221 - offsetX, 22 - offsetY);
        PathAddLineToPoint(path, nil, 210 - offsetX, 19 - offsetY);
        PathAddLineToPoint(path, nil, 197 - offsetX, 17 - offsetY);
        PathAddLineToPoint(path, nil, 189 - offsetX, 11 - offsetY);
        PathAddLineToPoint(path, nil, 177 - offsetX, 5 - offsetY);
        PathAddLineToPoint(path, nil, 166 - offsetX, 2 - offsetY);
        PathAddLineToPoint(path, nil, 152 - offsetX, 1 - offsetY);
        PathAddLineToPoint(path, nil, 136 - offsetX, 4 - offsetY);
        PathAddLineToPoint(path, nil, 121 - offsetX, 13 - offsetY);
        PathAddLineToPoint(path, nil, 111 - offsetX, 23 - offsetY);
        PathAddLineToPoint(path, nil, 107 - offsetX, 30 - offsetY);
        PathAddLineToPoint(path, nil, 97 - offsetX, 41 - offsetY);
        PathAddLineToPoint(path, nil, 95 - offsetX, 54 - offsetY);
        PathAddLineToPoint(path, nil, 94 - offsetX, 64 - offsetY);
        PathAddLineToPoint(path, nil, 97 - offsetX, 81 - offsetY);
        PathAddLineToPoint(path, nil, 101 - offsetX, 93 - offsetY);
        PathAddLineToPoint(path, nil, 106 - offsetX, 105 - offsetY);
        PathAddLineToPoint(path, nil, 114 - offsetX, 117 - offsetY);
        PathAddLineToPoint(path, nil, 120 - offsetX, 125 - offsetY);
        PathAddLineToPoint(path, nil, 129 - offsetX, 132 - offsetY);
        PathAddLineToPoint(path, nil, 121 - offsetX, 147 - offsetY);
        PathAddLineToPoint(path, nil, 107 - offsetX, 159 - offsetY);
        PathAddLineToPoint(path, nil, 92 - offsetX, 171 - offsetY);
        PathAddLineToPoint(path, nil, 81 - offsetX, 176 - offsetY);
        PathAddLineToPoint(path, nil, 68 - offsetX, 183 - offsetY);
        PathAddLineToPoint(path, nil, 61 - offsetX, 187 - offsetY);
        PathAddLineToPoint(path, nil, 56 - offsetX, 180 - offsetY);
        PathAddLineToPoint(path, nil, 50 - offsetX, 177 - offsetY);
        PathAddLineToPoint(path, nil, 39 - offsetX, 173 - offsetY);
        PathAddLineToPoint(path, nil, 24 - offsetX, 175 - offsetY);
        PathAddLineToPoint(path, nil, 14 - offsetX, 182 - offsetY);
        PathAddLineToPoint(path, nil, 10 - offsetX, 192 - offsetY);
        PathAddLineToPoint(path, nil, 7 - offsetX, 201 - offsetY);
        PathAddLineToPoint(path, nil, 11 - offsetX, 214 - offsetY);
        PathAddLineToPoint(path, nil, 18 - offsetX, 225 - offsetY);
        PathAddLineToPoint(path, nil, 28 - offsetX, 229 - offsetY);

    }
    

    
    
 
    
}