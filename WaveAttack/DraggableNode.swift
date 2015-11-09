//
//  DraggableNode.swift
//  WaveAttack
//
//  Created by yat on 27/10/2015.
//
//

import Foundation
import SpriteKit


class VerticalDraggableNode: SKCropNode , Draggable{
    var upperBound:CGFloat = CGFloat()
    var lowerBound : CGFloat = CGFloat()
    var content : SKSpriteNode = SKSpriteNode()
    var background : SKSpriteNode? = nil
    var touchframe : CGRect? = nil
    static func createNode (position : CGPoint, size: CGSize, lowerBound: CGFloat, upperBound: CGFloat)-> VerticalDraggableNode{
       // super.init(color: , size: )
        var res = VerticalDraggableNode()
        
        res.maskNode = SKSpriteNode(color: SKColor.redColor(), size: size)
        //res.content.color = SKColor.redColor()
    
        res.content.size = size
        res.touchframe = res.content.frame
        res.background  = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: size.width, height: size.height + upperBound))
        res.background!.anchorPoint = CGPoint(x: 0.5, y: 1)
        res.background!.position = CGPoint(x: 0, y: size.height/2)
        res.content.addChild(res.background!)
        //res.content.size = CGSize(width: size.width, height: size.height + upperBound)
        res.position = position
        res.addChild(res.content)
        res.upperBound = upperBound
        res.lowerBound = lowerBound
        
        return res
    }

    
    
    var velocity:CGFloat=0
    func scroll(dx: CGFloat, dy: CGFloat) {
        var newPos = CGPoint(x: content.position.x, y: content.position.y + dy)
        if (newPos.y < lowerBound){
            newPos = CGPoint(x:content.position.x, y: lowerBound)
        }else if newPos.y > upperBound{
            newPos = CGPoint(x:content.position.x, y: upperBound)

        }
        velocity=dy
        content.runAction(SKAction.moveTo(newPos, duration: 0))
        content.runAction(SKAction.waitForDuration(1/30), completion: continueScroll)
        
    }
    
    func continueScroll(){
        velocity *= 0.9
        if abs(velocity) < 1{
            velocity=0
        }
        else{scroll(0, dy:velocity)}
    }
    
    func checkTouch(touch: UITouch) -> Bool {
       // print(touch.locationInNode(self.parent!))
        //print(content.frame)
        return CGRectContainsPoint(content.frame,touch.locationInNode(self))

    }
    func scroll(x:CGFloat, y:CGFloat){
        
    }

}