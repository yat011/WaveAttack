//
//  GameObject.swift
//  WaveAttack
//
//  Created by yat on 11/9/2015.
//
//

import Foundation
import SpriteKit

class GameObject : NSObject {
    typealias CallBack = (GameObject, AnyObject?)->()
    
    override var hashValue: Int { return unsafeAddressOf(self).hashValue }
    var gameScene : GameScene? {
        get{return GameScene.current}
    }
    
    var eventFunc = [String : [CallBack]]()
    var name : String = ""
    var gameLayer:GameLayer {
        get{return GameScene.current!.gameLayer!}
    }
    
    func subscribeEvent ( event :String , call: CallBack){
        if eventFunc[event] == nil{
            var temp = [CallBack]()
            temp.append(call)
            eventFunc[event] =  temp
        }else{
            eventFunc[event]!.append(call)
        }
    }
    func triggerEvent( event: String){
        var subs = eventFunc[event]
        if subs == nil{
            return
        }
        // print("events \(event) \(subs!.count)")
        
        for f in subs!{
        
            f(self,nil)
        }
    }
    func triggerEvent( event: String, obj:AnyObject){
        var subs = eventFunc[event]
        if subs == nil{
            return
        }
        // print("events \(event) \(subs!.count)")
        
        for f in subs!{
            
            f(self,obj)
        }
    }
    
    func initialize(size : CGSize , position : CGPoint, gameScene :GameScene){
        fatalError("not implement")
    }
    
    func getSprite() -> SKNode?{
        return nil;
    }
    
    func update() -> (){
        
    }
    
    override init(){
        super.init()
    }
    
    init(_ gameScene :GameScene){
       // self.gameScene = gameScene
    }
    
    func deleteSelf(){ //to be overrided
        
    }
    
    
}

func ==(lhs: GameObject, rhs: GameObject) -> Bool {
    return lhs === rhs
}