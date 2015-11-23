//
//  GameScene.swift
//  WaveAttack
//
//  Created by yat on 11/9/2015.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

import SpriteKit
import CoreData

enum CollisionLayer : UInt32 {
    case GameBoundary = 0x1
    case Packet = 0x2
    case Medium = 0x4
    case Objects = 0x8
    case Ground = 0x10
    case FrontGround = 0x20
    case FrontObjects = 0x40
    case SmallObjects = 0x80
    case EnemyAttacks = 0x100
    case PlayerHpArea = 0x200
    case GarbageArea = 0x400
    case UndergroundArea = 0x800
    case Custom = 0x1000
}
enum GameObjectName : String{
    case Packet = "Packet"
    case GameBoundary = "boundary"
    case Medium = "Medium"
}


enum GameStage {
    case Superposition,Supering, SuperpositionAnimating, Attack, enemy,Temp,  Complete, Pause, Checking
}

enum TouchType {
    case gameArea , controlArea , button, waveButton, characterButton

}


class GameScene: TransitableScene , SKPhysicsContactDelegate{
    
   
    
    static weak var current: GameScene? = nil
    var gameLayer :GameLayer? = nil
    var infoLayer : InfoLayer? = nil
    var player : Player? = nil
    var controlLayer : UINode? = nil
    var _prevStage : GameStage? = nil
    var _currentStage : GameStage = GameStage.Superposition
    var currentStage : GameStage {get {return _currentStage}
        set(c){
            if (_currentStage == GameStage.Complete){
                return 
            }
            _prevStage = _currentStage
            _currentStage = c
        }
    }
    var contactQueue = Array<SKPhysicsContact>()
    var endContactQueue  = [SKPhysicsContact]()
   
    var playRect : CGRect? = nil  //showSize
    var controlRect : CGRect? = nil
    var gameArea : CGRect? = nil    //game Rect
    var packetArea: CGRect? = nil
    var mission : Mission? = nil
    var lenOfMission : Int  = 0
    var currentMission : Int = 0
   // let fixedFps : Double = 30
    var lastTimeStamp : CFTimeInterval = -100
   // var updateTimeInterval : Double
    var buttonList = Dictionary<GameStage, [Clickable]>()
    var objectHpBar : HpBar? = nil
    var resultUI : ResultUI? = nil
    var numRounds : Int = 0
    let grading = ["S","A","B","C","D","E","F"]
    var character : [Character?] = []
    var inited : Int = 0 //for texture
    var generalUpdateList = Set<Weak<GameObject>>()
    var totalScore :CGFloat = 0
    var bonus : Float {
        get{
            return 4 * exp(-Float(gameLayer!.totalTimer.currentTime)/60) + 1
        }
    }
    
    init(size: CGSize, missionId: Int,viewController:GameViewController) {
        
       
        super.init(size: size, viewController:viewController)
        self.scaleMode = .AspectFit
        selfScene=GameViewController.Scene.GameScene
        //updateTimeInterval = 1.0 / fixedFps33 
        GameScene.current = self

        // load mission
        self.gameArea = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: size.width * 3, height: size.height))
        self.packetArea = CGRect(origin: CGPoint(x: -100,y: -100), size: CGSize(width: size.width + 200, height: size.height + 200))
        
        mission =  Mission.loadMission(missionId,gameScene: self)
        
        
        //-------------------------

        
        
        srandom(UInt32(NSDate().timeIntervalSinceReferenceDate))

        let ph: CGFloat = size.height / 2
        let pPos = CGPoint(x: 0, y : ph)
        let psize  = CGSize(width: size.width, height: size.height / 2)
        playRect  = CGRect(origin: pPos, size: psize)
        controlRect = CGRect(origin: CGPoint(x: 0,y: 0), size: psize)
        lenOfMission = mission!.missions.count
        
  
        startSubMission(mission!.missions[0])
        
        
        
       
        
        
        backgroundColor = SKColor.whiteColor()
      
        
        
        
 
        //self.addChild(controlLayer)
        
        self.addChild(tapTimer)
        self.addChild(longTapTimer)
 
        
        physicsWorld.contactDelegate = self

       // var temp = ResultUI.createResultUI(CGRect(origin: CGPoint(x: self.size.width / 2,y: 320), size: CGSize(width: 300, height: 550)), gameScene : self)
        //self.addChild(temp)
     /*   for obj in gameLayer!.attackPhaseObjects{
            if obj is Medium{
                let medium = obj as! Medium
                var temp = SKShapeNode(path: medium.path!)
                gameLayer!.addChild(temp)
                
            }
        }*/
     }


    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func lateInit(){
        initControlLayer()
        var sumhp :CGFloat = 0
        for ch in character{
            guard ch != nil else{continue}
            sumhp += ch!.hp
            ch!.afterAddToScene()
        }
        var tplayer = Player(hp: sumhp)
        self.player = tplayer
        self.player!.subscribeEvent(GameEvent.HpChanged.rawValue, call: {
            sender, hp in
            let change = hp as! CGFloat
            if change > 0 {
               self.increaseHpEffect()
            }else{
               self.decreaseHpEffect()
            }
        })
        self.player!.subscribeEvent(GameEvent.PlayerDead.rawValue, call: self.playerDie)
        self.infoLayer = InfoLayer(position: CGPoint(x: 0,y: 640), player: tplayer, gameScene: self)
        self.addChild(infoLayer!)
    }
    

    func initControlLayer() -> (){
        let UIN = UINode(position: CGPoint(x: self.size.width/2,y: 0), parent:self)
        controlLayer = UIN
        UIN.zPosition=100000
        
      //  self.infoLayer = InfoLayer(position: CGPoint(x: 0,y: 640), player: tplayer, gameScene: self)
        self.addChild(UIN)

    }
// -------hp change effect ----- 
    func increaseHpEffect(){
       let hp = SKSpriteNode (imageNamed: "increaseHp")
        hp.size = self.size
        hp.anchorPoint = CGPoint()
        hp.zPosition = controlLayer!.zPosition + 100
        hp.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.5),SKAction.removeFromParent()]))
        self.addChild(hp)
    }
    func decreaseHpEffect(){
        let hp = SKSpriteNode (imageNamed: "decreaseHp")
        hp.size = self.size
        hp.anchorPoint = CGPoint()
        hp.zPosition = controlLayer!.zPosition + 100
        hp.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.5),SKAction.removeFromParent()]))
        self.addChild(hp)
    }
    
//-------------------- start Sub-Mission --------------------
    func startSubMission(subMission : SubMission){
        if gameLayer != nil{
            self.gameLayer!.deleteSelf()
            gameLayer!.removeFromParent()
            gameLayer = GameLayer(subMission: subMission, gameScene: self)
        }else{
            gameLayer = GameLayer(subMission: subMission, gameScene: self)
            
        }
        self.addChild(gameLayer!)
       gameLayer?.afterAddToScene()
        //var newY = gameLayer!.position.y + movement
        let diff = gameArea!.height - playRect!.size.height
        let lowerBound = playRect!.origin.y - diff
        gameLayer!.position = CGPoint(x:0 , y:lowerBound)
        controlLayer?.position = CGPoint(x: self.size.width/2, y: 0)
       // //print (gameArea!.origin.y)
       // //print(lowerBound)
        self.currentStage = GameStage.Temp
        gameLayer!.runAction(SKAction.moveToY(playRect!.origin.y, duration: 0), completion: {
            () -> () in
                self.createMissionLabel(self.currentMission + 1)
                self.startSuperpositionPhase()
            
            })
        
        
      
    }
    
//-------------------- phys detect-----------------------------------------
    func didBeginContact(contact: SKPhysicsContact) {
     //   //////print("contact")
        //////print ("A : \(contact.bodyA.node!.name) #\(unsafeAddressOf(contact.bodyA.node!)) , B : \(contact.bodyB.node!.name) #\(unsafeAddressOf(contact.bodyB.node!))")
       // self.contactQueue.append(contact)
       //     //////print (contact.contactPoint)
     ////////print(contact.contactNormal)
        
       /* if ( tryFindEnergyPacket(contact.bodyA.node, other: contact.bodyB.node, contact: contact) == true){
            return
        }else if (tryFindEnergyPacket(contact.bodyB.node, other: contact.bodyA.node, contact: contact) == true){
            return
        }else{
*/
       // print("impluse \(contact.collisionImpulse)")
    
        //print(contact.bodyA.node!.name)
        //print(contact.bodyB.node!.name)
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
                if currentStage == GameStage.Complete{
                    return true
                }
                
               var atk = (mA.node! as! GameSKSpriteNode).gameObject as! DirectAttack
                player?.changeHpBy(-atk.damage)
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
        if mA.categoryBitMask == CollisionLayer.Custom.rawValue {
            if mA.node != nil{
                let obj = mA.node as! GameSKSpriteNode
                guard obj.contactListener != nil else{ return true}
                
                obj.contactListener!.contactWith(mA, other: mB)
            }
            return true
            
        }else if mB.categoryBitMask == CollisionLayer.Custom.rawValue {
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

  

    
//----------------------touching --------------------------
    var touchType : TouchType? = nil
    var prevTouchPoint : CGPoint? = nil

    var isTap : Bool = false
    var tapTimer : SKNode = SKNode()
    var longTapTimer : SKNode = SKNode()
    var pressedDestObject : DestructibleObject? = nil
    var prevPressedObj : Clickable? = nil
    var destHpBarSize : CGSize = CGSize(width: 50, height: 10)
    var destHpBar : SKNode? = nil
    var clearUpNodes = Set<SKNode>()
    var pressedSkill : Skill? = nil
    var dragSkillObj : GameObject? = nil
    var pendingCharacter : Character? = nil
    
    
    func overTap() {
        isTap = false
    }
    
    
    
    
    func longPress(){
        if(touching){
            if (pressedDestObject != nil){ //hp bar
               longPressOnDest()
                
            }
        }
        
    }
    func longPressOnDest(){
        // //print("long press on obj")
        var sprite = pressedDestObject!.getSprite()!
        // //print(sprite.position)
        var hpbar = HpLabel(rect: CGRect(origin: convertTouchPointToGameAreaPoint(CGPoint(x: prevTouchPoint!.x - 25 , y: prevTouchPoint!.y + 30)) , size: destHpBarSize), max: pressedDestObject!.originHp, current: pressedDestObject!.hp, belongTo: pressedDestObject!)
        
      
        
        
        gameLayer?.addChild(hpbar)
        destHpBar = hpbar
        //clearUpNodes.insert(hpbar)
    }
    
    
    func convertTouchPointToGameAreaPoint( point: CGPoint) -> CGPoint{
        var res : CGPoint = point - gameLayer!.position
        return res
    }
    

    var dragVelocity : CGVector = CGVector()
    var dragging : SKNode?=nil
    var timerStarted=false
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if touching {
            clearTouch()
            
            return
        }
        
        if touches.count == 1 {//drag
            
            if let touch = touches.first  {

                    touching  = true
                    isTap = true
                    tapTimer.runAction(SKAction.waitForDuration(0.05),completion: overTap )
                    longTapTimer.removeAllActions()
                    longTapTimer.runAction(SKAction.waitForDuration(1),completion: longPress)
                    let touchDown =  touch.locationInNode(self)
                
                    checkPressOn(touchDown, touches: touches)
                
                

               /*
                if (CGRectContainsPoint(playRect!, touchDown)){
                        touchType = TouchType.gameArea
                    prevTouchPoint = touchDown
                    //print(CGRectContainsPoint(gameLayer.calculateAccumulatedFrame(), (touches.first?.locationInNode(gameLayer.parent!))!))
                }
                */

            }
        }else if touches.count > 1{
            prevTouchPoint = touches.first!.locationInNode(self)
        }

        
    }
    
    
    var superingTimer : FrameTimer? = nil
    var playerAttackArea = CGRect(x: 37.5, y: 0, width: 300, height: 20)
    func timeOut(){
        //print("timeOut")
        currentStage = .SuperpositionAnimating
       self.generalUpdateList.remove(Weak(self.superingTimer!))
        self.superingTimer?.stopTimer()
        self.controlLayer!.generatorUI!.stopAnimateStoringPower()
        self.clearTouch()
        controlLayer!.atkBtn!.hidden=true
        controlLayer?.animateSuperposition({
            ()->() in
            let resultWave=(self.childNodeWithName("UINode") as! UINode).drawSuperposition()
            self.controlLayer!.animateGeneration(resultWave, progress: self.superingTimer!.progress ,completion: {
                Void in
                self.controlLayer?.generatorUI?.close()
                self.superingTimer = nil
                
                self.timerStarted = false
                self.controlLayer!.stateLabel.hidden = false
                self.controlLayer!.lowerResultant = nil
                self.controlLayer!.upperResultant = nil
                self.startSuperpositionPhase()
            })
            
           /*self.gameLayer!.ground!.startVibrate(resultWave.getAmplitudes(), globalStartPoint: self.playerAttackArea.origin, completion: {
                () -> () in
                //print("completeion")
                self.superingTimer = nil
                
                self.timerStarted = false
                self.controlLayer!.stateLabel.hidden = false
                self.controlLayer!.lowerResultant = nil
                self.controlLayer!.upperResultant = nil
                self.startSuperpositionPhase()
            
            })
*/
         
        
        })
        
    }
    func startSupering(){
        var timelimit: CGFloat = player!.chargingTime
        var frameTimer = FrameTimer(duration: timelimit)
        self.superingTimer = frameTimer
        self.generalUpdateList.insert(Weak(frameTimer))
        frameTimer.startTimer(self.timeOut)
        self.controlLayer!.timerUI!.startTimer(timelimit)
        controlLayer!.generatorUI?.open()
        controlLayer!.generatorUI?.animateStoringPower(player!.numOfOscillation, maxTime: timelimit)
        controlLayer!.atkBtn!.hidden=false
        AnimateHelper.animateFlashEffect(controlLayer!.atkBtn!, duration: timelimit, completion: nil)
        frameTimer.updateFunc = {
            () -> () in
            self.controlLayer!.timerUI!.updateTimer()
            self.controlLayer!.timerUI!.updateBonusLabel( frameTimer.progress * (self.player!.timeBonus - 1) + 1)
            
            
        }
        
        self.currentStage = .Supering
        timerStarted=true
    }
    var waveData:[CGFloat]?
   
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
       
        ////print(touches.count)
        if (touches.count == 1 ) {//drag
             if (touching == false) {return}
             if (self.touchType == nil) { return }
            if let touch = touches.first {

                 let touchDown = touch.locationInNode(self)
                checkPressing(touchDown, touches: touches)
            }
        }else if (touches.count > 1){//multi touch scroll
            
            if (prevTouchPoint == nil || touching){
                clearTouch()
                prevTouchPoint = touches.first!.locationInNode(self)
           //     dragSkillObj?.getSprite()!.removeFromParent()
             //   dragSkillObj = nil
                return
            }
            touching = false
            
            var minlen:CGFloat = 1000000
            var touchDown = CGPoint()
            for touch in touches {
                var temp = touch.locationInNode(self)
                var diff:CGVector = (temp - prevTouchPoint!)
                ////print("diff \(diff.length)")
                if diff.length < minlen {
                    minlen = diff.length
                    touchDown = temp
                }
                
                
            }
            let diff :CGVector =  prevTouchPoint! - touchDown
            // //print(diff)
            var move = 2 * diff
            move = 0.5 * (prevMove + move)
            prevMove = move
            dragVelocity = (-1 * move)
            prevTouchPoint = touchDown
            
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touching){
            
            checkEndPress(touches)
            
        }
        clearTouch()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        clearTouch()
    }
    
    
    
    func checkPressOn(touchDown :CGPoint,touches: Set<UITouch>){
        
        
        if (CGRectContainsPoint(CGRect(origin: CGPoint(), size: gameArea!.size), touches.first!.locationInNode(gameLayer!))){
            touchType = TouchType.gameArea
            prevTouchPoint = touchDown
            if pressedSkill != nil{
                touchesBeganSkill(prevTouchPoint!, touches: touches)
                return
            }else{
                for gameObject in (gameLayer?.attackPhaseObjects)!{ // find GameObject pressed
                    if gameObject is DestructibleObject{
                        var medium = gameObject as! DestructibleObject
                        var mediumPt = medium.getSprite()!.convertPoint(touchDown, fromNode: self)
                       // if (CGPathContainsPoint(medium.path!, nil, mediumPt, true)){
                        //    pressedDestObject = medium
                        //}
                    }
                }
                
            
              
            }
        }else if (currentStage == GameStage.Superposition || currentStage == GameStage.Supering) && CGRectContainsPoint(controlRect!, touchDown){ // control Layer
            touchType = TouchType.controlArea
            prevTouchPoint = touchDown
            for ch in character{
                guard ch != nil else{continue}
                if (CGRectContainsPoint(ch!.waveUI!.calculateAccumulatedFrame(), (touches.first?.locationInNode(ch!.waveUI!.parent!))!))
                {
                    //do action
                    touchType = TouchType.waveButton
                    dragging=ch!.waveUI
                    break
                }
            }
        /*
            for c in (self.childNodeWithName("UINode")?.childNodeWithName("UIWaveButtonGroup")!.children)!
            {
                ////print(c.description)
                ////print(CGRectContainsPoint(c.frame, (touches.first?.locationInNode(c.parent!))!))
                //check clicked on Button
                if (CGRectContainsPoint(c.calculateAccumulatedFrame(), (touches.first?.locationInNode(c.parent!))!))
                {
                    //do action
                    touchType = TouchType.waveButton
                    dragging=c
                    break
                }
            }
*/
      
        }
        //button
        var btns = self.buttonList[currentStage]
       // //print(btns!.count)
        if btns != nil{
            for btn in btns! {
                ////print(touchDown)
                var clicked = btn.checkClick(touchDown)
                
                if clicked != nil{
                    touchType = TouchType.button
                    prevPressedObj = clicked
                }
            }
        }
        
     
    }
    var prevMove: CGVector  = CGVector()
    
    func checkPressing(touchDown :CGPoint,touches: Set<UITouch>){
        if (prevTouchPoint == nil){
            prevTouchPoint = touchDown
        }
        let diff :CGVector =  prevTouchPoint! - touchDown
       // //print(diff)
        var move = 2 * diff
        move = 0.5 * (prevMove + move)
        prevMove = move
        if (touchType! == TouchType.gameArea){ //
            
            prevTouchPoint  = touchDown
            if (pressedSkill != nil && touchesMovedSkill(touchDown, touches: touches) == false){
                return
            }
            if (self.currentStage == GameStage.Superposition || self.currentStage == GameStage.Attack || self.currentStage == GameStage.enemy || self.currentStage == GameStage.Supering || self.currentStage == GameStage.SuperpositionAnimating || self.currentStage == GameStage.Complete){
                scrollLayers(-1*move)
                dragVelocity = (-1 * move)
            }
            if pressedDestObject != nil { //long pressed object
                var mediumPt = pressedDestObject!.getSprite()!.convertPoint(touchDown, fromNode: self)
               /* if (CGPathContainsPoint(pressedDestObject!.path!, nil, mediumPt, true) != true){
                    pressedDestObject = nil
                    destHpBar?.removeFromParent()
                    destHpBar = nil
                }*/
                
            }
            
        }else if(touchType! == TouchType.waveButton){ //
            if(!timerStarted){
              startSupering()
            }
            prevTouchPoint  = touchDown
           // //print(diff.dx)
            (dragging as! UIWaveButton).scroll(-diff.dx,dy: 0)
            
        }else if (touchType == TouchType.button){
            if prevPressedObj == nil{
                return
            }else {
                if prevPressedObj?.checkClick(touchDown) ==  nil{
                    prevPressedObj = nil
                    return
                }
            }
        }
    }
    func checkEndPress (touches: Set<UITouch>){
        if self.currentStage == GameStage.Superposition{
            
            if touchType == TouchType.gameArea{
                if (pressedSkill != nil && touchesEndedSkill(prevTouchPoint!, touches: touches) == false){
                    return
                }
                if (isTap){
                  //  tempCreatePacket()
                 //   startAttackPhase()
                }
            }else{
                if isTap{
                 //   clickOnControlLayer()
                }
            }
        }
        if (touchType == TouchType.button){
            if prevPressedObj == nil{
                return
            }else {
                prevPressedObj!.click()
            }
        }
        
    }
    
    
    func touchesBeganSkill(touchDown :CGPoint,touches: Set<UITouch>){
        if (pressedSkill is PlacableSkill){
          /*  let temp =  pressedSkill as! PlacableSkill
            var gameObj = temp.createGameObj(gameLayer!.maxZIndex, gameScene: self)
            gameObj.getSprite()!.runAction(SKAction.fadeAlphaTo(0.3, duration: 0))
            gameObj.getSprite()!.position = touchDown
            gameLayer?.addGameObject(gameObj)
            dragSkillObj = gameObj
*/
        }else if (pressedSkill is TargetSkill){
            
        }
    }
    func touchesMovedSkill(touchDown :CGPoint,touches: Set<UITouch>) -> Bool{
        if (pressedSkill is PlacableSkill){
             if (CGRectContainsPoint(CGRect(origin: CGPoint(), size: gameArea!.size), touches.first!.locationInNode(gameLayer!))){
                dragSkillObj?.getSprite()!.runAction(SKAction.moveTo(convertTouchPointToGameAreaPoint(touchDown), duration: 0))
                return false
            }else {
              //  pressedSkill = nil
                clearTouch()
                return false
            }
        }else if (pressedSkill is TargetSkill){
            
        }
        return false
    }
    
    func touchesEndedSkill (touchDown :CGPoint,touches: Set<UITouch>) -> Bool{
        if (pressedSkill is PlacableSkill){
             if (CGRectContainsPoint(CGRect(origin: CGPoint(), size: gameArea!.size), touches.first!.locationInNode(gameLayer!))){
                dragSkillObj?.getSprite()!.runAction(SKAction.moveTo(convertTouchPointToGameAreaPoint(touchDown), duration: 0))
                dragSkillObj?.getSprite()!.runAction(SKAction.fadeAlphaTo(1, duration: 0))
               // pendingCharacter!.resetRound()
                pendingCharacter = nil
                dragSkillObj = nil
                pressedSkill = nil
                return false
            }else {
                //  pressedSkill = nil
                clearTouch()
                return false
            }
        }else if (pressedSkill is TargetSkill){
            
        }
        return false
    }
    
   
    func scrollLayers(movement: CGVector){
        ////print(gameArea)
        
        var newY = gameLayer!.position.y + movement.dy
        var newX = gameLayer!.position.x + movement.dx
       // print(gameLayer!.position.x)
        let diff = gameArea!.height - playRect!.size.height
        let lowerBound = playRect!.origin.y - diff
        let lowestBoundX = -gameArea!.width + self.viewController!.screenSize.width
        
        
        if newY < lowerBound{
            newY = lowerBound
        }else if newY > playRect!.origin.y {
            newY = playRect!.origin.y
        }
        
        newY = playRect!.origin.y
        if newX < lowestBoundX{
            newX = lowestBoundX
        }else if newX > 0 {
            newX = 0
        }
        
       let moveTo = CGPoint(x: newX, y: newY)
        
        gameLayer!.runAction(SKAction.moveTo(moveTo,duration: 0))
        gameLayer!.runAction(SKAction.waitForDuration(1/30), completion: continueScroll)
        //gameLayer!.playerHpArea!.runAction(SKAction.moveToX(playerAttackArea.size.width/2 + playerAttackArea.origin.x - moveTo.x, duration: 0))
        controlLayer!.scroll(0, y: newY-self.size.height/2)
        
    }
    func continueScroll(){
        if ((dragVelocity.length != 0) && (touching == false))
        {
            scrollLayers(dragVelocity)
            dragVelocity = 0.9 * dragVelocity
            if (abs(dragVelocity.dy) < 5) {dragVelocity.dy = 0}
            if (abs(dragVelocity.dx) < 5) {dragVelocity.dx = 0}
        }
    }
   
    func setPendingSkill( character : Character){
        if pressedSkill != nil{
            pendingCharacter!.canelSkill()
        }
        pressedSkill = character.skill!
        pendingCharacter = character
        
    }
    func clearSkill(){
        
        pressedSkill = nil
        pendingCharacter = nil

    }
  
    
    func clearTouch (){
        if (dragSkillObj != nil){
            gameLayer!.removeGameObject(dragSkillObj!)
            dragSkillObj = nil
        }
        
        tapTimer.removeAllActions()
        touching = false
        touchType = nil
        pressedDestObject = nil
        destHpBar?.removeFromParent()
        destHpBar = nil
        prevTouchPoint = nil
        prevMove = CGVector()
        dragging = nil
    }
    
   
    
    
    var countFrame :Int = 0
    var counter:Int=0
    override func update(currentTime: CFTimeInterval) {
       
        switch (currentStage){
        case .Attack:
            
      //      handleContact()
       //     attackPhaseUpdate(currentTime)
           
            break
        case .Superposition:
            moveWaves()
            break
        case .Supering:
            moveWaves()
            break
        default:
            break
        }
       attackPhaseUpdate(currentTime)
        for each in generalUpdateList{
            each.value?.update()
        }
        
      


        
        
        //smooth scrolling

      
    
        if inited == 1{ // init
            lateInit()
        }
            inited++
        
    
    }
    func moveWaves(){
        for var each in character{
            guard each != nil else{continue}
            if each!.waveUI === dragging
            {
                if timerStarted == true{
                    continue
                }
            }
            each!.moveWave()
        }
    }
    
//----------- phase change -----------------------------
   
    func startCheckResult(){
        self.currentStage = GameStage.Checking
       // if gameLayer!.checkResult() == false {
            
        //}
        startSuperpositionPhase()
    }
    
    func startSuperpositionPhase(){
        self.currentStage = GameStage.Superposition
        //print("start superposition")
        /*
        for var each in self.character{
            
            guard each != nil else{continue}
            each!.nextRound()
        }
*/
        if numRounds > 0{
            controlLayer!.showWaveButtons()
            controlLayer!.timerUI!.resetTimer()
            controlLayer!.stateLabel.hidden = true
            
        }
        numRounds += 1
    }
    
    func startAttackPhase(){
        self.currentStage = GameStage.Attack
        //print("start attack phase")
        
    }
    
    
    
    
    
//------------------------------------------------------
   
    
    func attackPhaseUpdate (currentTime: CFTimeInterval){
        gameLayer!.update(currentTime)
    }
    
    
    func getMediumFromBodyB (contact : SKPhysicsContact) -> Medium? {
        if ( contact.bodyB.node?.parent == nil){
            return nil
        }
        return  ((contact.bodyB.node as! HasGameObject?)?.gameObject as! Medium?)
    }
    
    
    //
    func completeSubMission(){
        currentMission += 1
        if (currentMission >= mission?.missions.count){ // complete Mission
            currentStage = GameStage.Complete
            //print("complete Mission")
          
            if PlayerInfo.playerInfo!.passMission?.integerValue < mission!.missionId{
                PlayerInfo.playerInfo!.passMission = mission!.missionId
            }
            var missionObj = PlayerInfo.getPassedMissionById(mission!.missionId)
            if missionObj == nil{
                missionObj = NSManagedObject.insertObject("PassedMission") as! PassedMission
                var set = PlayerInfo.playerInfo!.passedMissions as! NSMutableSet?
                if set == nil{
                    set = NSMutableSet()
                    PlayerInfo.playerInfo!.passedMissions = set
                }
                set!.addObject(missionObj!)
            }
            var finalScore = Float(totalScore) * bonus
            print(missionObj!.score)
            if missionObj!.score == nil || missionObj!.score!.floatValue <= finalScore{
                //missionObj!.roundUsed = numRounds
                //missionObj!.grade = getGrade()
                missionObj!.missionId = mission!.missionId
                missionObj!.score = finalScore
                
            }
            
            
            
            NSManagedObject.save()
            controlLayer?.stateLabel.text = "Complete"
         
            self.resultUI = ResultUI.createResultUI(CGRect(origin: CGPoint(x: self.size.width / 2,y: 320), size: CGSize(width: 300, height: 550)), gameScene : self)
            self.addChild(self.resultUI!)
            
            //numRounds = 20
            self.resultUI!.showResult({
                () -> () in
                //print("finished")
            })
            
            return
            
 
           
        }
        currentStage = GameStage.Temp
        controlLayer?.stateLabel.text = "Changing Scene ..."
        
        
        //self.createMissionLabel(self.currentMission + 1)
        gameLayer!.fadeOutAll({
            () -> () in
           
            
            self.startSubMission((self.mission?.missions[self.currentMission])!)

        })
        
    }
    
    func getGrade() -> String{
        
        var grades = mission!.gradeDiv
     
        for var i = 0 ; i < grades.count ; i++ {
            print(grades[i])
            if numRounds < grades[i]{
                return grading[i]
            }
            
            
        }
        return  "F"
    }
    
    func playerDie(obj :GameObject, nth : AnyObject?){
         currentStage = GameStage.Complete
        controlLayer?.stateLabel.text = "You Lose ..."
        self.resultUI = ResultUI.createResultUI(CGRect(origin: CGPoint(x: self.size.width / 2,y: 320), size: CGSize(width: 300, height: 550)), gameScene : self)
        self.resultUI!.title!.text = "Mission Failure"
        self.addChild(self.resultUI!)
        let smoke =   SKEmitterNode(fileNamed: "Smoke.sks")
        let fire = SKEmitterNode(fileNamed: "Fire.sks")
        var fireNode=SKSpriteNode()
        fireNode.addChild(smoke!)
        fireNode.addChild(fire!)
        fireNode.zPosition = GameLayer.ZFRONT + 1
        fire!.zPosition = 1
        
        controlLayer?.generatorUI!.addChild(fireNode)
        //numRounds = 20
        self.resultUI!.showLose({
            () -> () in
           
        })

    }
    
    
    
    func createMissionLabel(current : Int){

        createFlashLabel("Mission \(current)/\(mission!.missions.count)")

    
    }
    func createFlashLabel(text : String){
        let label = SKLabelNode(text: text)
        label.position = CGPoint(x: self.size.width / 2, y: 500)
        label.zPosition = 10000
        label.fontName = "Helvetica"
        label.verticalAlignmentMode = .Center
        let back = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 200, height: 80))
        back.alpha = 0.7
        back.zPosition = -1
        label.addChild(back)
        let seq : [SKAction] = [SKAction.waitForDuration(2) , SKAction.fadeOutWithDuration(0.5)]
        
        self.addChild(label)
        label.runAction(SKAction.sequence(seq), completion :
            { () -> () in
                label.removeFromParent()
        })
        
        
    }
    
    
    func BackToMenu(){
        self.viewController!.sceneTransitionBackward()
    }
    
    
//---------manage Clickable
    func addClickable(stage: GameStage, _ click : Clickable) {
        if self.buttonList[stage] == nil{
            self.buttonList[stage] = []
        }
        self.buttonList[stage]!.append(click)
    }
    //---remove -------
    
    
    // recover prevStage
    func resumeStage(){
        if (_prevStage != nil){
            _currentStage = _prevStage!
        }
    }
    
//------------------------
    override func didSimulatePhysics() {
        for each in gameLayer!.attackPhaseObjects{
            guard each is Medium else{
                continue
            }
            let medium = each as! Medium
            medium.syncPos()
        }
    }
   
}



class ContactContainer {
    var outOfArea : Bool = false
    var mediumContacted = Set<Medium>()
    var enter = [(Medium,ContactInfo)]()
    var exit = [(Medium,ContactInfo)]()
    
}

class ContactInfo {
    var contactPoint : CGPoint
    var contactNormal : CGVector
    
    init (_ cont:SKPhysicsContact){
        contactPoint = cont.contactPoint
        contactNormal = cont.contactNormal
    }

}




