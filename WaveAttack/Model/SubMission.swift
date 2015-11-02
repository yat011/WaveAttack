//
//  SubMission.swift
//  WaveAttack
//
//  Created by yat on 21/9/2015.
//
//

import Foundation
import SpriteKit

class SubMission{
    
    var terrain: Medium? = nil
    var objects: [Medium] = []
    var zIndex : Int = 1
    
    static func parseJsonObj( obj : [String:AnyObject] , gameScene : GameScene) -> SubMission?{
        var zIndex =  1
        var terrainStr = (obj["terrain"] as! String)
        
        var sub = SubMission()
        
        sub.terrain = GameObjectFactory.getInstance().create(terrainStr) as! Medium
        var terrainPos = gameScene.gameArea!.origin + CGPoint(x:gameScene.gameArea!.size
            .width/2, y: gameScene.gameArea!.size.height / 2)
            sub.terrain!.initialize(gameScene.size, position: terrainPos, gameScene: gameScene)
        
        
        var objects = obj["object"] as! [AnyObject]
        for dictObj in objects{
            var dict = dictObj as! [String : AnyObject]
           // print (dict["type"])

            var medium: Medium = GameObjectFactory.getInstance().create(dict["type"]! as! String) as! Medium
            var x : CGFloat = CGFloat((dict["x"]! as! NSNumber).floatValue)
            var y : CGFloat = CGFloat((dict["y"]! as! NSNumber).floatValue)
            y = gameScene.gameArea!.size.height -  y
            
            var width : CGFloat = CGFloat((dict["width"]! as! NSNumber).floatValue)
            var height : CGFloat = CGFloat((dict["height"]! as! NSNumber).floatValue)
            
            if medium.getSprite()! is SKSpriteNode{
                let node = medium.getSprite() as! SKSpriteNode
                x =  x + node.anchorPoint.x * width
                y = y + node.anchorPoint.y * height
            }else if medium.getSprite()! is SKShapeNode{
                let node = medium.getSprite() as! SKShapeNode
                y = y + 0.5 * height
            }
            if let name = dict["name"]{
                medium.name = name as! String
            }
// ------------ properties--------------
            
           
    
            
            medium.initialize(CGSize(width: width, height: height), position: CGPoint(x: x, y: y), gameScene: gameScene)
          
            let properties = dict["properties"] as![String: AnyObject]
            
            
            var bTarget : Bool = false
            if let target = (properties["target"] ){
                bTarget = (target as! NSString).boolValue
            }
            if (medium is DestructibleObject){
                let des = medium as! DestructibleObject
                des.target = bTarget
                if let hpStr = properties["hp"] {
                    des.originHp = CGFloat((hpStr as! NSString).floatValue)
                }
            }
            
            if let rotation  = dict["rotation"]{
                medium.getSprite()!.runAction(SKAction.rotateByAngle(CGFloat((rotation as! NSNumber).floatValue), duration: 0))
            }
           
            medium.zIndex = zIndex
            sub.objects.append(medium)
            zIndex += 1
            
 
            
        }
        sub.zIndex = zIndex
        
        return sub
    }
    
}