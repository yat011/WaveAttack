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
    func checkTouch(touch:UITouch)->Bool
    func getRect () -> CGRect
    func click()
}

extension Clickable where Self:SKNode{
    func checkTouch(touch:UITouch)->Bool{
        return CGRectContainsPoint(self.frame,touch.locationInNode(self.parent!))
    }
    func getRect () -> CGRect {
        return CGRect()
    }
    func click(){
        
    }
    func checkClick(touchPoint: CGPoint) -> Clickable? {
      
        return nil
    }

}


extension Clickable where Self : SKSpriteNode{
    func checkClick(touchPoint: CGPoint) -> Clickable? {
        let rect  = getRect()
        if (CGRectContainsPoint(rect, touchPoint)){
            return self
        }
        return nil
    }
    func checkTouch(touch:UITouch)->Bool{
        return CGRectContainsPoint(MathHelper.nodeToCGRect(self),touch.locationInNode(self.parent!))
    }
    func getRect () -> CGRect {
        return CGRect()
    }
    func click(){
        
    }

}
protocol Draggable:Clickable{
    func scroll(dx:CGFloat, dy:CGFloat)
    func scroll(x:CGFloat, y:CGFloat)
}
/*
extension Draggable where Self:SKNode{
    func scroll(dx:CGFloat, dy:CGFloat){
        let newX = self.position.x + dx
        self.runAction(SKAction.moveToX(newX, duration: 0))
    }
}
*/