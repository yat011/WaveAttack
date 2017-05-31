//
//  PassedMission+CoreDataProperties.swift
//  WaveAttack
//
//  Created by yat on 21/11/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PassedMission {

    @NSManaged var grade: String?
    @NSManaged var missionId: NSNumber?
    @NSManaged var roundUsed: NSNumber?
    @NSManaged var score: NSNumber?

}
