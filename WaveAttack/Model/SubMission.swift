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
    
    static func parseJsonObj( obj : [String:AnyObject] , gameScene : GameScene) -> SubMission?{
        var zIndex =  1
        var terrainStr = (obj["terrain"] as! String)
        
        var sub = SubMission()
        
        sub.terrain = GameObjectFactory.getInstance().create(terrainStr) as! Medium
        sub.terrain!.initialize(gameScene.size, position: gameScene.gameArea!.origin, gameScene: gameScene)
        
        
        var objects = obj["object"] as! [AnyObject]
        for dictObj in objects{
            var dict = dictObj as! [String : String]
            print (dict["type"])

            var medium: Medium = GameObjectFactory.getInstance().create(dict["type"]!) as! Medium
            var x : CGFloat = CGFloat((dict["x"]! as NSString).floatValue)
            var y : CGFloat = CGFloat((dict["y"]! as NSString).floatValue)
            var width : CGFloat = CGFloat((dict["width"]! as NSString).floatValue)
            var height : CGFloat = CGFloat((dict["height"]! as NSString).floatValue)
            var bTarget : Bool = false
            if let target = dict["target"]{
                if target == "true"{
                    bTarget = true
                }
            }
            
            medium.initialize(CGSize(width: width, height: height), position: CGPoint(x: x, y: y), gameScene: gameScene)
            if (medium is DestructibleObject){
                let des = medium as! DestructibleObject
                des.target = bTarget
                if let hpStr = dict["hp"] {
                    des.hp = CGFloat((hpStr as NSString).floatValue)
                }
            }
            medium.zIndex = zIndex
            sub.objects.append(medium)
            zIndex += 1
            
 
            
        }
        
        
        return sub
    }
    
}