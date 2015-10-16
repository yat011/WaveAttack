//
//  Mission.swift
//  WaveAttack
//
//  Created by yat on 21/9/2015.
//
//

import Foundation

class Mission{
    
    var missionId : Int = 0
    var missions:[SubMission] = []
    var complete : Int = 0
    weak var gameScene : GameScene? = nil
    var gradeDiv : [Int] = []
    
    static func loadMission ( index : Int, gameScene : GameScene) -> Mission?{
        var mission : Mission = Mission()
        mission.missionId = index
        var name:String = "mission\(index)"
        if let dict = Dictionary<String, AnyObject>.loadJSONFromBundle(name){
            var subMissions: [AnyObject] = dict["subMission"]! as! [AnyObject]
            for subObj in subMissions{
               mission.missions.append(SubMission.parseJsonObj(subObj as! [String : AnyObject], gameScene: gameScene)!)
            }
            mission.gradeDiv = dict["grade"]! as! [Int]
            print(mission.gradeDiv)
            
        }
        
        
        
        return mission
    }
}