//
//  Mission.swift
//  WaveAttack
//
//  Created by yat on 21/9/2015.
//
//

import Foundation

class Mission{
    
    var missions:[SubMission] = []
    var complete : Int = 0
    weak var gameScene : GameScene? = nil
    
    static func loadMission ( index : Int, gameScene : GameScene) -> Mission?{
        var mission : Mission = Mission()
        
        var name:String = "mission\(index)"
        if let dict = Dictionary<String, AnyObject>.loadJSONFromBundle(name){
            var subMissions: [AnyObject] = dict["subMission"]! as! [AnyObject]
            for subObj in subMissions{
               mission.missions.append(SubMission.parseJsonObj(subObj as! [String : AnyObject], gameScene: gameScene)!)
            }
            
        }
        
        
        return mission
    }
}