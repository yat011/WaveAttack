//
//  OwnedCharacter+CoreDataProperties.swift
//  WaveAttack
//
//  Created by yat on 21/10/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension OwnedCharacter {

    @NSManaged var characterId: NSNumber?
    @NSManaged var teamPosition: NSNumber?
    @NSManaged var belongTo: NSManagedObject?

    
}
