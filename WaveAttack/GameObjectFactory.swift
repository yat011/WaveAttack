//
//  GameObjectFactory.swift
//  WaveAttack
//
//  Created by yat on 21/9/2015.
//
//

import Foundation

class GameObjectFactory{
    typealias closure = ()-> GameObject
    
    var hash = [String : closure]()
    static var _this: GameObjectFactory? = nil
    
    
    private init(){
        
    }
    
    public static func getInstance()->GameObjectFactory{
        if (_this == nil){
            _this = GameObjectFactory()
        }
        return _this!
    }
    
  
    
    func create(name: String) -> GameObject?{
       // print(name)
      
        let classobj : AnyClass = NSClassFromString("WaveAttack.\(name)")!
        var gameObj = classobj as! NSObject.Type
        let temp = gameObj.init()
        
        return temp as! GameObject
        /*
        var function = hash[name]
        if (function != nil){
            return function!()
        }
        return nil
*/
    }
    func createByFullName(name: String) -> GameObject?{
        // print(name)
        
        let classobj : AnyClass = NSClassFromString(name)!
        var gameObj = classobj as! NSObject.Type
        let temp = gameObj.init()
        
        return temp as! GameObject
        /*
        var function = hash[name]
        if (function != nil){
        return function!()
        }
        return nil
        */
    }
}