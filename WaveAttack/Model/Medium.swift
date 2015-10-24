//
//  Medium.swift
//  WaveAttack
//
//  Created by yat on 13/9/2015.
//
//

import Foundation
import SpriteKit
class Medium : GameObject {
    
    var propagationSpeed : Double = 3
    var zIndex: Int = 0
   
    var collisionAbsorption: CGFloat = 0
    var packets = Set<EnergyPacket>()
    var physContactSprite: GameSKSpriteNode = GameSKSpriteNode()
    var path: CGPath? { get{
        //print(getSprite()!.frame)
        var rect = CGRect(origin: CGPoint(x:  -getSprite()!.frame.size.width/2 , y: -getSprite()!.frame.size.height/2), size: getSprite()!.frame.size)
        var path = CGPathCreateWithRect(rect, nil)
        //var t = CGPathCreateMutableCopy(path)
        //CGPathMoveToPoint(t, nil, getSprite()!.position.x, getSprite()!.position.y)
        return path
    
        }}
    override init(){
        super.init()
        physContactSprite.gameObject = self
        

    }
    
    init(size : CGSize , position : CGPoint, gameScene :GameScene){
        
        super.init()
       physContactSprite.gameObject = self
        initialize(size, position: position, gameScene: gameScene)
      
    }
    func initialize(size : CGSize , position : CGPoint, gameScene :GameScene){
        fatalError("not implement")
    }
    
    func getEdgePhysicsBody() -> SKPhysicsBody?{
        fatalError("not implement")
        return nil
    }
    
    func addPacketRef ( packet: EnergyPacket){
        packets.insert(packet)
        
    }
    func removePacketRef (packet: EnergyPacket){
        packets.remove(packet)
    }
    override func deleteSelf() {
        super.deleteSelf()
        physContactSprite.removeFromParent()
    }
    
}