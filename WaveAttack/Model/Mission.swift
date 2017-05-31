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
    static var missionList = [Int: String]()
    var announcements = [String]()
    static func loadMission ( index : Int, gameScene : GameScene) -> Mission?{
        var mission : Mission = Mission()
        mission.missionId = index
        var name:String = "mission\(index)"
        if let dict = Dictionary<String, AnyObject>.loadJSONFromBundle(name){
            var subMissions: [AnyObject] = dict["subMission"]! as! [AnyObject]
            for subObj in subMissions{
               mission.missions.append(SubMission.parseJsonObj(subObj as! [String : AnyObject], gameScene: gameScene)!)
            }
            mission.announcements = dict["announcements"] as! [String]
            
        }
        
        
        
        return mission
    }
    
   
    static func initMissionList(){
        print("init mission list")
        for (var index = 1 ; ; index++){
           var name:String = "mission\(index)"
            if let dict = Dictionary<String, AnyObject>.loadJSONFromBundle(name){
                var name = dict["name"]! as! String
                missionList[index] = name
            }else{
                break;
            }
        }
        
        
    }
    
}