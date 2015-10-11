//
//  Clickable.swift
//  WaveAttack
//
//  Created by yat on 9/10/2015.
//
//

import Foundation
import SpriteKit
protocol Clickable {
    func checkClick(touchPoint : CGPoint)-> Clickable?
    func getRect () -> CGRect
    func click()
}


extension Clickable where Self : SKSpriteNode{
    func checkClick(touchPoint: CGPoint) -> Clickable? {
        var rect  = getRect()
        if (CGRectContainsPoint(rect, touchPoint)){
            return self
        }
        return nil
    }
}