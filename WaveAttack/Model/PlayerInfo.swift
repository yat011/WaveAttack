//
//  PlayerInfo.swift
//  WaveAttack
//
//  Created by yat on 16/10/2015.
//
//

import Foundation
import CoreData
import UIKit

class PlayerInfo: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    static var _playerInfo : PlayerInfo? = nil
    static var playerInfo : PlayerInfo? { get {return _playerInfo}}
    static var team: Team {
        get {
            return (PlayerInfo.playerInfo!.teams!.allObjects[0] as! Team)
        }
    }
    
    static func getPassedMissionById(id :Int) -> PassedMission?{
        let fetchRequest = NSFetchRequest(entityName: "PassedMission")
        fetchRequest.predicate = NSPredicate(format: "missionId = %i", id)
        
        do{
            var app = (UIApplication.sharedApplication().delegate as! AppDelegate)
            
            
            let fetchResults:[NSManagedObject] = try app.managedObjectContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            if (fetchResults.count > 0){
                return fetchResults[0] as! PassedMission
            }else{
                return nil
            }
            
        }catch {
            return nil
        }
    }
    
    
}
