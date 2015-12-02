//
//  GameLayer.swift
//  WaveAttack
//
//  Created by yat on 13/9/2015.
//
//

import Foundation
import SpriteKit


class GameLayer : SKNode ,SKPhysicsContactDelegate{
    
   let  boundary : [SKShapeNode] = []
    var background : Medium? = nil
    var attackPhaseObjects = [GameObject]()
  //  var energyPackets = Set<EnergyPacket>()
    var ground  : Ground? = nil
   // var gameArea = CGRect()
    weak var subMission: SubMission? = nil
    var totalTarget: Int = 0
    var completed = false
    static let ZFRONT :CGFloat = 10, ZNORMAL :CGFloat = 9, ZBACK :CGFloat = 0
    var validArea : CGRect? = nil
    weak var gameScene: GameScene? = nil
    var enterables = [Enterable]()
    var spawnPoints = [Int:[SpawnPoint]]()
    var validTimer = FrameTimer(duration: 0.5)
    var totalTimer = FrameTimer(duration: 1e6)
    var attackStarted = false
    var stage: Int  = 1 //spawnPoint stage
    var playerHpArea : SKSpriteNode? = nil
    var earthquaking :Bool = false
    var tempHumans = [Human]()
    init(subMission : SubMission, gameScene : GameScene) {
       
       self.subMission = subMission
        self.gameScene = gameScene
        super.init()
        validArea  = CGRect(x: -50, y: -50, width: gameScene.gameArea!.width + 100, height: gameScene.gameArea!.height + 100)
    
        
        
        background = subMission.terrain
        self.addChild(background!.getSprite()!)
    
        var humans = [Human]()
        for medium in subMission.objects{
            if medium is Human{
                tempHumans.append(medium as! Human)
                continue
            }
            
            addGameObject(medium)
            if (medium is Ground){
                ground = medium as! Ground
                ground!.subscribeEvent(GameEvent.EarthquakeStart.rawValue, call: {
                    (obj : GameObject, any) -> () in
                        self.earthquaking = true
                    self.startAttack()
                })
                ground!.subscribeEvent(GameEvent.EarthquakeEnd.rawValue, call: {
                    obj in
                    self.earthquaking = false
                    
                })
            }
        }
        
        
        spawnPoints = subMission.spawnPoints

        initBoundary()
        initGarbageArea()
        let left = TargetPoint()
        left.pos = CGPoint(x: -100, y: ground!.frontY)
        let right = TargetPoint()
        right.pos = CGPoint(x: validArea!.width + (validArea?.origin.x)! + 50, y: ground!.frontY)
        enterables.append(left)
        enterables.append(right)
        
        
        
    }

    func initBoundary (){
        var boundary = SKSpriteNode()
        let phys = SKPhysicsBody(edgeLoopFromRect: CGRect(origin: CGPoint(x:0, y: -gameScene!.gameArea!.height), size: CGSize(width: gameScene!.gameArea!.width, height: 3 * gameScene!.gameArea!.height)))
        phys.categoryBitMask = CollisionLayer.GameBoundary.rawValue
        phys.collisionBitMask = 0
        phys.contactTestBitMask = 0
        phys.usesPreciseCollisionDetection = true
        phys.dynamic = false
        boundary.physicsBody = phys
        
        boundary.name = "boundary"
        
        self.addChild(boundary)
        
    }
    func initPlayerDamageArea(){
        var playerArea = SKSpriteNode(color: SKColor.greenColor(), size: gameScene!.playerAttackArea.size)
        let phys = SKPhysicsBody(rectangleOfSize: gameScene!.playerAttackArea.size)
        phys.dynamic = false
        phys.categoryBitMask = CollisionLayer.PlayerHpArea.rawValue
        phys.collisionBitMask = 0
        phys.contactTestBitMask = 0
        playerArea.physicsBody=phys
        playerArea.zPosition = 100000
        playerArea.position = CGPoint(x: gameScene!.playerAttackArea.origin.x + gameScene!.playerAttackArea.size.width/2, y: 10 )
       // gameScene!.addChild(playerArea)
        playerHpArea = playerArea
        self.addChild(playerArea)
    }
    func initGarbageArea(){
        var tempSize  = CGSize(width: gameScene!.gameArea!.width + 1000, height: 100)
        var area = SKSpriteNode()
        let phys = SKPhysicsBody(rectangleOfSize: tempSize)
        phys.dynamic = false
        phys.categoryBitMask = CollisionLayer.GarbageArea.rawValue
        phys.collisionBitMask = 0
        phys.contactTestBitMask = CollisionLayer.EnemyAttacks.rawValue | CollisionLayer.FrontObjects.rawValue | CollisionLayer.Objects.rawValue | CollisionLayer.SmallObjects.rawValue
        area.physicsBody=phys
        area.zPosition = 100000
        area.position = CGPoint(x: gameScene!.gameArea!.size.width/2, y: -300 )
        // gameScene!.addChild(playerArea)
        self.addChild(area)
    }
    
    func afterAddToScene(){
        for each in tempHumans{
            var rep = Human()
            rep.spawnInit(each.sprite.position)
            addGameObject(rep)
        }
        tempHumans.removeAll()
        for each in attackPhaseObjects{
            if each is Medium{
                let medium = each as! Medium
                medium.afterAddToScene()
            }
        }
        for each in spawnPoints[stage]!{
            each.afterAddToScene()
        }
   
    
        gameScene!.generalUpdateList.insert(Weak(validTimer))
        totalTimer.startTimer(nil)
        gameScene!.generalUpdateList.insert(Weak(totalTimer))
    }
//--------------- Spawn stage-----------------
    func startAttack(){
        if self.stage == 1{
            //show some notice
            self.changeSpawnState()
        }
    }
    
    
    var targetSpawnCount = 0
    func changeSpawnState(){
        self.stage++
        targetSpawnCount = 0
        if spawnPoints[self.stage] == nil{
            //or do sth 
            // show win
            if gameScene!.currentStage != GameStage.Complete{
                self.completeMission()
            }
            return
        }
        self.gameScene!.infoLayer!.announcement.showTextLabel(gameScene!.mission!.announcements[self.stage-2])
        for each in self.spawnPoints[self.stage]!{
            if each.limited {
                targetSpawnCount++
                each.subscribeEvent(GameEvent.EnemyDefeat.rawValue, call: {
                    (obj:GameObject, nth) -> () in
                    self.targetSpawnCount--
                    if self.targetSpawnCount == 0 {
                        self.changeSpawnState()
                    }
                })
            }
            each.afterAddToScene()
        }
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scored (obj : GameObject , score:AnyObject?){
        guard gameScene!.currentStage != GameStage.Complete else{ return}
        guard obj is DestructibleObject else{return }
        let destObj = obj as! DestructibleObject
        var score = destObj.dynamicType.score[destObj.scoredIndex]
        gameScene!.totalScore += score
        gameScene!.infoLayer!.scoreLabel!.setScore(gameScene!.totalScore)
        self.addChild(ScoreFlashMsg(score,destObj))
    }
    func addGameObject(obj : GameObject){
        attackPhaseObjects.append(obj)
        if (obj is Medium){
            let temp  = obj as! Medium
           //self.addChild(temp.physContactSprite)
        }
        if (obj is DestructibleObject){
            obj.subscribeEvent(GameEvent.Scored.rawValue, call: self.scored)
        }
        if (obj.getSprite() != nil){
            self.addChild(obj.getSprite()!)
        }
    }
    
    func removeGameObject (obj : GameObject){
        if attackPhaseObjects.removeObject(obj) != nil{
            updateIndex = (updateIndex - 1)%self.attackPhaseObjects.count
            obj.deleteSelf()
        }
    
        
    }
//---
    //-------------------- phys detect-----------------------------------------
    func didBeginContact(contact: SKPhysicsContact) {
        
        if (checkHitPlayer(contact.bodyA, mB: contact.bodyB)){
            return
        }
        if (checkGarbage(contact.bodyA, mB: contact.bodyB)){
            return
        }
        if (checkCustom(contact.bodyA, mB: contact.bodyB)){
            return
        }
        
        guard contact.bodyA.node is GameSKSpriteNode && contact.bodyB.node is GameSKSpriteNode else{
            return
        }
        var nodeA = contact.bodyA.node! as! GameSKSpriteNode
        var nodeB = contact.bodyB.node! as! GameSKSpriteNode
        
        
        collisionDamage(nodeA.gameObject as! Medium?, mB: nodeB.gameObject as! Medium?, contact: contact)
        
    }
    func checkHitPlayer (mA : SKPhysicsBody , mB: SKPhysicsBody ) -> Bool{
        if mA.categoryBitMask == CollisionLayer.EnemyAttacks.rawValue {
            if (mB.categoryBitMask == CollisionLayer.PlayerHpArea.rawValue){
                if mA.node == nil {
                    return true
                }
                if gameScene!.currentStage == GameStage.Complete{
                    return true
                }
                
                var atk = (mA.node! as! GameSKSpriteNode).gameObject as! DirectAttack
                gameScene!.player?.changeHpBy(-atk.damage)
                mA.node?.removeFromParent()
                return true
            }
            return false
            
        }else if mB.categoryBitMask == CollisionLayer.EnemyAttacks.rawValue {
            return checkHitPlayer(mB, mB: mA)
        }
        return false
    }
    func checkCustom (mA : SKPhysicsBody , mB: SKPhysicsBody ) -> Bool{
        if mA.categoryBitMask & CollisionLayer.Custom.rawValue  > 0{
            if mA.node != nil{
                let obj = mA.node as! GameSKSpriteNode
                guard obj.contactListener != nil else{ return true}
                
                obj.contactListener!.contactWith(mA, other: mB)
            }
            return true
            
        }else if mB.categoryBitMask & CollisionLayer.Custom.rawValue > 0{
            return checkCustom(mB, mB: mA)
        }
        return false
    }
    func checkGarbage (mA : SKPhysicsBody , mB: SKPhysicsBody ) -> Bool{
        if mA.categoryBitMask == CollisionLayer.GarbageArea.rawValue{
            if mB.node == nil {
                return  true
            }
            if (mB.node! is GameSKSpriteNode){
                let gnode = mB.node as! GameSKSpriteNode
                if gnode.gameObject != nil{
                    if gnode.gameObject! is DestructibleObject{
                        (gnode.gameObject as! DestructibleObject).garbageCollected()
                    }
                }
            }
            mB.node?.removeFromParent()
            
            
            
            return true
            
        }else if mB.categoryBitMask == CollisionLayer.GarbageArea.rawValue {
            return checkGarbage(mB, mB: mA)
        }
        return false
    }
    func collisionDamage(mA : Medium?, mB:Medium?, contact : SKPhysicsContact){
        
        if mA != nil && mA! is DestructibleObject{
            let dest = mA as! DestructibleObject
            dest.impulseDamage(contact.collisionImpulse,contactPt: contact.contactPoint)
            
        }
        if mB != nil && mB! is DestructibleObject{
            let dest = mB as! DestructibleObject
            dest.impulseDamage(contact.collisionImpulse, contactPt: contact.contactPoint)
        }
        
    }
    
    
    
    
    
//--------------------- update   --------------
    var updateIndex = 0
    var groundUpdateIndex = 0
    func update(start: Double){
        
        for obj in  attackPhaseObjects{
            
            
            if obj is Ground{
               if groundUpdateIndex == 0{
                   obj.slowUpdate()
                }
            }else{
                obj.slowUpdate()
            }

        }
        groundUpdateIndex = (groundUpdateIndex+1)%10

       
        
    }
   
//----------------------------------------------------
    
    func fadeOutAll(finish :(() -> ())){
        var temp : SKNode = SKNode()
        for obj in self.children{
            if obj === self.background!.getSprite()!{
                continue
            }
            obj.runAction(SKAction.fadeOutWithDuration(1))
            
        }
        
        self.addChild(temp)
        temp.runAction(SKAction.waitForDuration(1.2),completion: finish)
       
       
        
    }
    
    
    
    func deleteSelf(){
        for  gameObj in attackPhaseObjects{
            gameObj.deleteSelf()
        }
        attackPhaseObjects.removeAll()
        background!.deleteSelf()
        background = nil
        
    }
  
    
 
    func completeMission(){
        self.gameScene!.completeSubMission()
    }
    
    
   
}


