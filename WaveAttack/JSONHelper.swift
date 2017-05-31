//
//  JSONHelper.swift
//  WaveAttack
//
//  Created by James on 9/10/15.
//
//

import Foundation
import SpriteKit

class JSONHelper{
    static func loadJSON(filename: String) -> Dictionary<String, AnyObject>? {
        var res : Dictionary<String, AnyObject>? = nil
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
            
            do{
                let data = try NSData(contentsOfFile: path, options: NSDataReadingOptions())
                let dictionary = try NSJSONSerialization.JSONObjectWithData(data,options: NSJSONReadingOptions())
                print (dictionary)
                res = dictionary  as? Dictionary<String, AnyObject>
                return res
            }
            catch {
                print("Error loading JSON file: \(filename) ")
                print("Check syntax")
                return nil
            }
        } else {
            print("JSON file not found: \(filename)")
            return nil
        }
    }
    
    //"key":"value"
    static func getValue(dict:Dictionary<String,AnyObject>, key:String)->NSString{
        return dict[key] as! NSString
    }
    //"key":{OBJ}
    static func getObject(dict:Dictionary<String,AnyObject>, key:String)->Dictionary<String,AnyObject>{
        return dict[key] as! Dictionary<String,AnyObject>
    }
    //"key":[ARRAY]
    static func getArray(dict:Dictionary<String,AnyObject>, key:String)->NSArray{
        return dict[key] as! NSArray
    }
    //"key":[{ITEM}]
    static func getArrayItem(dict:Dictionary<String,AnyObject>, key:String, index:Int)->Dictionary<String,AnyObject>{
        return (getArray(dict, key: key)[index]) as! Dictionary<String, AnyObject>
    }
    
    //"key":[{ITEM},{ITEM},{ITEM}]
    static func getArrayCount(dict:Dictionary<String,AnyObject>, key:String)->Int{
        return getArray(dict, key: key).count
    }
}