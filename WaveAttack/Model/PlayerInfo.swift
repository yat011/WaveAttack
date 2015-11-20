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
            print(PlayerInfo.playerInfo!.teams!.allObjects.count)
            return (PlayerInfo.playerInfo!.teams!.allObjects[0] as! Team)
        }
    }
    
    static func getPassedMissionById(id :Int) -> PassedMission?{
        var test = NSManagedObject.getObjects("PassedMission") as! [PassedMission]
        print(test.count)
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
    
    static func changeTeamCharacter(atPos : Int, character:OwnedCharacter?){
        var list:[OwnedCharacter] = team.characters!.allObjects as! [OwnedCharacter]
        for var i = 0 ; i < list.count ; i++ {
            if list[i].teamPosition!.integerValue == atPos{
                if character == nil{
                  //  list.removeAtIndex(i)
                    
                    list[i].belongTo = nil
                    list.removeAtIndex(i)
                }else{
                    character!.teamPosition = atPos
                    list[i].belongTo = nil
                    character!.belongTo = team
                }
                
               
                return
            }
        }
        //not found
        if (character == nil){
            return
        }
        // insert
        character!.teamPosition = atPos
        list.append(character!)
        team.characters = NSMutableSet(array: list)
        return
    }
    
    static func createOwnedCharacter(character: Character) -> OwnedCharacter{
        var ch = NSManagedObject.insertObject("OwnedCharacter")
        var ch2 = ch as! OwnedCharacter
       // ch2.teamPosition = 0
        ch2.characterId = character.ID
        return ch2
    }
    
    static func getCharacterAt(pos:Int)-> OwnedCharacter?{
        var list:[OwnedCharacter] = team.characters!.allObjects as! [OwnedCharacter]
        print(list.count)
        for ch in list{
            if ch.teamPosition!.integerValue == pos{
                return ch
            }
        }
        return nil
    }
    static func getAllOwnedCharacter() -> [OwnedCharacter]{
        return NSManagedObject.getObjects("OwnedCharacter") as! [OwnedCharacter]
    }
    static func checkInTeam(owned : OwnedCharacter)-> Bool{
        var list:[OwnedCharacter] = team.characters!.allObjects as! [OwnedCharacter]
        print(list.count)
        for ch in list{
            if ch === owned{
                return true
            }
        }
        return false
    }
    
   
}
