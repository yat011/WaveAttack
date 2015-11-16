//
//  GameLayer.swift
//  WaveAttack
//
//  Created by yat on 13/9/2015.
//
//

import Foundation
import SpriteKit


class GameLayer : SKNode{
    
   let  boundary : [SKShapeNode] = []
    var background : Medium? = nil
    var attackPhaseObjects = Set<GameObject>()
    var energyPackets = Set<EnergyPacket>()
    var ground  : Ground? = nil
   // var gameArea = CGRect()
    weak var subMission: SubMission? = nil
    var totalTarget: Int = 0
    var completed = false
    static let ZFRONT :CGFloat = 10, ZNORMAL :CGFloat = 9, ZBACK :CGFloat = 0
    var validArea : CGRect? = nil
    weak var gameScene: GameScene? = nil
    var enterables = [Enterable]()
    var spawnPoints = [SpawnPoint]()
    var validTimer = FrameTimer(duration: 0.5)
    
    init(subMission : SubMission, gameScene : GameScene) {
       
       self.subMission = subMission
        self.gameScene = gameScene
        super.init()
        validArea  = CGRect(x: -50, y: -50, width: gameScene.gameArea!.width + 100, height: gameScene.gameArea!.height + 100)
    
        
        
         //gameArea = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: size.width, height: 2 * size.height))//temp
        background = subMission.terrain
       // print(background!.getSprite()!)
        self.addChild(background!.getSprite()!)
       // print ("upper screen size \(gameArea))")
       // gameArea = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: size.width, height: 2 * size.height))//temp
        
   
        var deadCallBack =  {
            
            (obj : GameObject)-> () in
            if (obj is DestructibleObject){
                var des = obj as! DestructibleObject
                if des.target{
                    self.totalTarget -= 1
                    self.checkResult()
  
                }
            }
            
            
        }
    
        for medium in subMission.objects{
            if (medium is DestructibleObject){
                var des = medium as! DestructibleObject
                if des.target {
                    totalTarget += 1
                  // self.addChild(des.hpBar!)
                }
                if des is EnemyActable{
                    //self.addChild(des.roundLabel!)
                }
                des.subscribeEvent(GameEvent.Dead.rawValue, call: deadCallBack)
                
            }
            addGameObject(medium)
            if (medium is Ground){
                ground = medium as! Ground
            }
        }
        spawnPoints = subMission.spawnPoints
        

        initBoundary()
        let left = EndPoint()
        left.pos = CGPoint(x: -100, y: ground!.frontY)
        let right = EndPoint()
        right.pos = CGPoint(x: validArea!.width + (validArea?.origin.x)! + 50, y: ground!.frontY)
        enterables.append(left)
        enterables.append(right)
        
    }

    func initBoundary (){
        var boundary = SKSpriteNode()
        let phys = SKPhysicsBody(edgeLoopFromRect: CGRect(origin: CGPoint(), size:  gameScene!.gameArea!.size))
        phys.categoryBitMask = CollisionLayer.GameBoundary.rawValue
        phys.collisionBitMask = CollisionLayer.Objects.rawValue | CollisionLayer.FrontObjects.rawValue
        phys.contactTestBitMask = 0
        phys.usesPreciseCollisionDetection = true
        boundary.physicsBody = phys
        boundary.name = "boundary"
        
        self.addChild(boundary)
        
    }
    
    func afterAddToScene(){
        for each in attackPhaseObjects{
            if each is Medium{
                let medium = each as! Medium
                medium.afterAddToScene()
            }
        }
        for each in spawnPoints{
            each.afterAddToScene()
        }
        var f :(()->())? = nil
        f = {
            ()->() in
            for each in self.attackPhaseObjects{
                if (each is DestructibleObject){
                    (each as! DestructibleObject).checkOutOfArea()
                }
            }
            self.validTimer.reset()
            self.validTimer.startTimer(f!)
        }
        validTimer.startTimer(f!)
        gameScene!.generalUpdateList.insert(validTimer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGameObject(obj : GameObject){
        attackPhaseObjects.insert(obj)
        if (obj is Medium){
            let temp  = obj as! Medium
           //self.addChild(temp.physContactSprite)
        }
        
        if (obj is EnergyPacket){
            energyPackets.insert(obj as! EnergyPacket)
        }
        if (obj.getSprite() != nil){
            self.addChild(obj.getSprite()!)
        }
    }
    
    func removeGameObject (obj : GameObject){
        attackPhaseObjects.remove(obj)
       obj.deleteSelf()
        if  (obj is EnergyPacket){
            energyPackets.remove(obj as! EnergyPacket)
        }
    
        
        if (obj.getSprite() != nil){
            obj.getSprite()!.removeFromParent()
        }
       
        
    }
//--------------------- update   --------------
    func update(currentTime: CFTimeInterval){
     //   if (self.energyPackets.count == 0){
     //       gameScene!.startCheckResult()
     //      // gameScene!.startEnemyPhase()
     //       return
     //   }
        
        
        for obj in  attackPhaseObjects{
            obj.update()
        }
        for obj in spawnPoints{
            obj.update()
        }
    }
    func enemyDoAction(){
        enermyActionCounter = 0
        waitForActionComplete = false
        for obj in attackPhaseObjects{
            if obj is EnemyActable{
                var temp = obj as! EnemyActable
                enermyActionCounter += 1
                temp.nextRound(self.actionFinish)
            }
        }
        waitForActionComplete = true
        checkEnemyFinish()
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
    
    var enermyActionCounter : Int = 0
    var waitForActionComplete:Bool = false
    func actionFinish(){
        enermyActionCounter -= 1
        if waitForActionComplete {
            checkEnemyFinish()
        }
    }
    func checkEnemyFinish(){
        if gameScene!.player?.hp <= 0 {
            gameScene!.playerDie()
            return
        }
        
        if enermyActionCounter == 0{
            //complete
            gameScene!.startSuperpositionPhase()
        }
    }
    
 
    func completeMission(){
        print ("clear one submissoin")
        self.gameScene!.completeSubMission()
    }
    
    func checkResult() -> Bool{
        return false
        if completed == true{
            return true
        }
        if self.totalTarget == 0{
            completed = true
            self.completeMission()
            return true
        }
        return false
    }
   
}


