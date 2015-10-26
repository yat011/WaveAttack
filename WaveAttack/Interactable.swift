//
//  interactable.swift
//  WaveAttack
//
//  Created by James on 23/10/15.
//
//

import Foundation
import SpriteKit

protocol _Clickable{
    func getClass()->String
    func checkTouch(touch:UITouch)->Bool
    //func checkTouch(touchPoint:CGPoint)->Bool
}
extension _Clickable where Self : SKSpriteNode{
    func checkTouch(touch:UITouch)->Bool{
        return CGRectContainsPoint(MathHelper.nodeToCGRect(self),touch.locationInNode(self.parent!))
    }
    func checkTouch(touchPoint:CGPoint)->Bool{
        return CGRectContainsPoint(MathHelper.nodeToCGRect(self),touchPoint)
    }
}
extension _Clickable where Self : SKNode{
    func checkTouch(touch:UITouch)->Bool{
        return CGRectContainsPoint(self.calculateAccumulatedFrame(),touch.locationInNode(self.parent!))
    }
    func checkTouch(touchPoint:CGPoint)->Bool{
        return CGRectContainsPoint(self.calculateAccumulatedFrame(),touchPoint)
    }
}