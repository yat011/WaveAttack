//
//  DestructibleObject.swift
//  WaveAttack
//
//  Created by yat on 14/9/2015.
//
//

import Foundation
import SpriteKit
class DestructibleObject : Medium {
    
    private var _originHp : CGFloat = 1000
    var originHp: CGFloat {
        get { return _originHp}
        set(v) {
            _originHp = v
            _hp = v
            if target == true{
                createHpBar()
            }
        }
    
    }
    var hp : CGFloat { get {return _hp} }
    private var _hp : CGFloat = 1000
    var absorptionRate :CGFloat = 0.05
    var damageReduction :CGFloat = 0
    var scaleX: CGFloat  = 1
    var scaleY : CGFloat = 1
    var totDmg: CGFloat = 0
    var disappearThreshold: CGFloat = -100
    var target : Bool {
        get { return _target }
        set(v) {
            _target = v
            if v == true{
                createHpBar()
            }
        }
    }
    var _target : Bool = false
    var scaled : Bool = false
    var prevScale : CGFloat = 1
    
    override var path: CGPath? { get{ return _path}}
    var xDivMax: CGFloat  {get { fatalError(); return 1}}
    var yDivMax: CGFloat {get {fatalError() ; return 1}}
    var _path : CGPath? = nil
    var moveRound : Int = 3
    var currentRound : Int = 0
    var hpBar : HpBar? = nil
    var hpBarRect :CGRect? = nil
    var roundLabel : ActRoundLabel? = nil
    var roundRect : CGRect? = nil
    
    
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
        if getSprite() == nil {
            fatalError("sprite == nil")
        }
        self.gameScene = gameScene
        var sprite :GameSKSpriteNode = self.getSprite()! as! GameSKSpriteNode
        var originSize = sprite.size
        sprite.position = position
         sprite.size = size

        sprite.gameObject = self
         createPhysicsBody(originSize, targetSize: size)
        var selfPos = getSprite()!.position
        var barpos = CGPoint(x: selfPos.x - self.getSprite()!.frame.width / 2 + 5 ,y: selfPos.y - self.getSprite()!.frame.height / 2  - 15)
        hpBarRect = CGRect(origin: barpos, size: CGSize(width: self.getSprite()!.frame.width - 10, height: 10))
        if (self is EnemyActable){
            
            roundRect = CGRect(x: selfPos.x + self.getSprite()!.frame.width / 2, y: selfPos.y - self.getSprite()!.frame.height / 2  - 15, width: 10, height: 13)
            roundLabel = ActRoundLabel.createActRoundLabel(roundRect!, enemy: self as! EnemyActable)
        }
    }
    
    
    
    func createPhysicsBody(originSize:CGSize, targetSize:CGSize){
        // print (sprite.frame.size)
        //print (sprite.anchorPoint)
        //  sprite.anchorPoint.x = 0
        // sprite.anchorPoint.y = 0
        //let offsetX:CGFloat = 0
        //let offsetY:CGFloat = 0
        //var xyratio = originSize.width / originSize.height
        var xDiv : CGFloat = xDivMax
        var yDiv: CGFloat = yDivMax
        print ("\(xDiv) \(yDiv)")
        
        self.scaleX = targetSize.width / xDiv
        self.scaleY = targetSize.height / yDiv
        let path = CGPathCreateMutable();
        
        
        drawPath(path, offsetX: 0 , offsetY: 0)
        
        CGPathCloseSubpath(path);
        
        _path = path
        //print(CGPathContainsPoint(path, nil,CGPoint(x: 0, y: 0) , true))
        
        let phys = SKPhysicsBody (edgeLoopFromPath: path)
        
        phys.usesPreciseCollisionDetection = true
        phys.collisionBitMask = 0x0
        //phys.affectedByGravity = false
        phys.categoryBitMask = CollisionLayer.Medium.rawValue
        
        getSprite()!.physicsBody = phys
    }
    
    func drawPath(path: CGMutablePath, offsetX : CGFloat, offsetY: CGFloat){
        fatalError("drawPath not implemented")
    }
    
    
    
    
    
    
   
    
    
    func calculateDamage(packet : EnergyPacket){
        var damage: CGFloat = packet.energy * absorptionRate
        packet.energy = packet.energy - damage
        damage = damage - damageReduction
        if (damage < 0){
            damage = 0
        }
        _hp = hp - damage
        totDmg = totDmg + damage
        if (hp < 0){
//            print("destory")
        }
        
       triggerEvent(GameEvent.HpChanged.rawValue)
        
        
        return
    }
    
    
    
    func PathAddLineToPoint( path: CGMutablePath, _ nth: UnsafePointer<CGAffineTransform>,_ x : CGFloat,_ y: CGFloat) -> (){
        let tempx = x * scaleX
        let tempy: CGFloat = y * scaleY
        var sprite = self.getSprite()! as! SKSpriteNode
        let offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
        let offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
        CGPathAddLineToPoint(path, nil, CGFloat(tempx) - offsetX , CGFloat(tempy) - offsetY);
    }
    
    func PathMoveToPoint( path: CGMutablePath, _ nth: UnsafePointer<CGAffineTransform>,_ x : CGFloat,_ y: CGFloat) -> (){
        let tempx = x * scaleX
        let tempy: CGFloat = y * scaleY
        var sprite = self.getSprite()! as! SKSpriteNode
        let offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
        let offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
        CGPathMoveToPoint(path, nil, CGFloat(tempx) - offsetX , CGFloat(tempy) - offsetY);
        
    }
    
   var prevAction :SKAction? = nil
    var animating : Bool = false
    func expandComplete(){
        
        getSprite()!.runAction(prevAction!.reversedAction(), completion: completeShake)
    }
    func completeShake(){
        animating = false
    }
    
    func shaking(){
        
   
        if (totDmg < 80){
            prevScale =  totDmg * 0.1 / 80
        }else{
            prevScale = 0.1
        }
        var oriSize = (getSprite()! as! SKSpriteNode).size
        //(getSprite()! as! SKSpriteNode).size = CGSize(width: prevScale * oriSize.width, height: prevScale *  oriSize.height)
        prevAction = SKAction.resizeByWidth(prevScale * oriSize.width, height: prevScale * oriSize.height, duration: 0.1)
        animating = true
        getSprite()!.runAction(prevAction!, completion: expandComplete)
        scaled = true
        
    }
    
    override func update() {
        if (totDmg != 0 && animating == false){
            shaking()
        }
        totDmg = 0
        if (hp < disappearThreshold){
            //destory self and inside packet
            destorySelf()
        }
        
        
    }
    
    
    func destorySelf(){
        for obj in self.packets{
            if (obj.deleted == false){
                obj.deleteSelf()
            }
        }
        if hpBar != nil{
            hpBar!.removeFromParent()
        }
        if roundLabel != nil{
            roundLabel!.removeFromParent()
        }
        
        self.gameScene!.gameLayer!.removeGameObject(self)
        
    }
//-------misc-------
    func createHpBar(){
        if hpBar != nil{
            hpBar!.removeFromParent()
            hpBar = nil
            
        }
       
        hpBar = HpBar.createHpBar(hpBarRect!, max: self.originHp, current: self.hp, belongTo: self)
        
        hpBar!.zPosition = self.getSprite()!.zPosition + 1
        //gameScene!.gameLayer!.addChild(hpBar!)
    }
    
}