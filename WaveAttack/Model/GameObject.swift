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
    typealias CallBack = (GameObject)->()
    
    override var hashValue: Int { return unsafeAddressOf(self).hashValue }
    weak var gameScene : GameScene? = nil
    
    var eventFunc = [String : [CallBack]]()
    
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
        for f in subs!{
            f(self)
        }
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
        self.gameScene = gameScene
    }
    
    func deleteSelf(){ //to be overrided
        
    }
    
    
}

func ==(lhs: GameObject, rhs: GameObject) -> Bool {
    return lhs === rhs
}