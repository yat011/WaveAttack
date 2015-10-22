//
//  PlayerInfo+CoreDataProperties.swift
//  WaveAttack
//
//  Created by yat on 16/10/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PlayerInfo {

    @NSManaged var passMission: NSNumber?
    @NSManaged var teams:NSSet?
}
