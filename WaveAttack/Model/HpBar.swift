//
//  File.swift
//  WaveAttack
//
//  Created by yat on 23/9/2015.
//
//

import Foundation
import SpriteKit

class HpBar : SKShapeNode {
    
    var max : Int = 1
    var current : Int = 0
    var hpBar : SKSpriteNode? = nil
    
    
    static func createHpBar(rect: CGRect, max : Int , current : Int) -> HpBar{
        var bar = HpBar(rect: rect, cornerRadius: 2)
       // super.init(rectOfSize: size, cornerRadius: 2)
        bar.max = max
        bar.current = current
        bar.hpBar = SKSpriteNode(imageNamed: "redbar")
        bar.hpBar!.size = rect.size
        bar.hpBar!.anchorPoint = CGPoint(x: 0,y: 0)
        bar.addChild(bar.hpBar!)
        return bar
    }
    

    
    
}