//
//  CoreDataExtension.swift
//  WaveAttack
//
//  Created by yat on 5/11/2015.
//
//

import Foundation
import CoreData
import UIKit

extension NSManagedObject {
    static func getObjects (name:String) -> [NSManagedObject]?{
        let fetchRequest = NSFetchRequest(entityName: name)
        do{
            var app = (UIApplication.sharedApplication().delegate as! AppDelegate)
            
            
            let fetchResults:[NSManagedObject] = try app.managedObjectContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            return fetchResults
            
            /*
            // Create an Alert, and set it's message to whatever the itemText is
            //if (fetchResults.count > 0){
            //print("hv existing data")
            //  PlayerInfo._playerInfo = fetchResults[0]
            }else{
            print("no existing data")
            // let newItem = NSEntityDescription.insertNewObjectForEntityForName("PlayerInfo", inManagedObjectContext: self.managedObjectContext!) as! PlayerInfo
            //  PlayerInfo._playerInfo = newItem
            // PlayerInfo.playerInfo!.passMission = 0
            
            
            }
            */
        }catch {
            return nil
        }
    }
    static func insertObject(name:String) -> NSManagedObject?{
        
        var app = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        //print("no existing data")
        let newItem = NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: app.managedObjectContext!)
        return newItem
        
    }
    
    
    static func save(){
        var app = (UIApplication.sharedApplication().delegate as! AppDelegate)
        do{
            try app.managedObjectContext!.save()
            print("saved")
        }catch{
            print("fail")
        }
    }
}