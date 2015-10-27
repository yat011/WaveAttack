//
//  PlayerInfo.swift
//  WaveAttack
//
//  Created by yat on 16/10/2015.
//
//

import Foundation
import CoreData


class PlayerInfo: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    static var _playerInfo : PlayerInfo? = nil
    static var playerInfo : PlayerInfo? { get {return _playerInfo}}
    static var team: Team {
        get {
            return (PlayerInfo.playerInfo!.teams!.allObjects[0] as! Team)
        }
    }
    
    
    
}
