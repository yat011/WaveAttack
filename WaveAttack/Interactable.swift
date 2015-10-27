//
//  interactable.swift
//  WaveAttack
//
//  Created by James on 23/10/15.
//
//

import Foundation
import SpriteKit

protocol Interactable{
    func getClass()->String
    func checkTouch(touch:UITouch)->Bool
    //func checkTouch(touchPoint:CGPoint)->Bool
    //func onClick()
    //func onMove()
    //func onHold()
}
extension Interactable where Self : SKSpriteNode{
    func checkTouch(touch:UITouch)->Bool{
        return CGRectContainsPoint(MathHelper.nodeToCGRect(self),touch.locationInNode(self.parent!))
    }
    func checkTouch(touchPoint:CGPoint)->Bool{
        return CGRectContainsPoint(MathHelper.nodeToCGRect(self),touchPoint)
    }
}
extension Interactable where Self : SKNode{
    func checkTouch(touch:UITouch)->Bool{
        return CGRectContainsPoint(self.calculateAccumulatedFrame(),touch.locationInNode(self.parent!))
    }
    func checkTouch(touchPoint:CGPoint)->Bool{
        return CGRectContainsPoint(self.calculateAccumulatedFrame(),touchPoint)
    }
}