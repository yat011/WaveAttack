//
//  GameScene.swift
//  WaveAttack
//
//  Created by yat on 11/9/2015.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

import SpriteKit

enum CollisionLayer : UInt32 {
    case GameBoundary = 0x1
    case Packet = 0x2
    case Medium = 0x4
}
enum GameObjectName : String{
    case Packet = "Packet"
    case GameBoundary = "boundary"
    case Medium = "Medium"
}


enum GameStage {
    case Superposition, Attack, enemy,Temp,  Complete, Pause, Checking
}

enum TouchType {
    case gameArea , controlArea , button, waveButton, characterButton

}

class GameScene: SKScene , SKPhysicsContactDelegate{
   
    var viewController:GameViewController?
    
    var gameLayer :GameLayer? = nil
    var infoLayer : InfoLayer? = nil
    var player : Player? = nil
    var controlLayer : UINode? = nil
    var currentStage : GameStage = GameStage.Superposition
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
    
    var objectHpBar : HpBar? = nil
    var resultUI : ResultUI? = nil
    var numRounds : Int = 0
    let grading = ["S","A","B","C","D","E","F"]
    override init(size: CGSize) {
        
     
        //updateTimeInterval = 1.0 / fixedFps33 
        super.init(size: size)
        // load mission
        self.gameArea = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: size.width, height: size.height))
        self.packetArea = CGRect(origin: CGPoint(x: -100,y: -100), size: CGSize(width: size.width + 200, height: size.height + 200))
        
        mission =  Mission.loadMission(1,gameScene: self)
        
        
        //-------------------------

        CharacterManager.parse("")
        
        srandom(UInt32(NSDate().timeIntervalSinceReferenceDate))

        let ph: CGFloat = size.height / 2
        let pPos = CGPoint(x: 0, y : ph)
        let psize  = CGSize(width: size.width, height: size.height / 2)
        playRect  = CGRect(origin: pPos, size: psize)
        controlRect = CGRect(origin: CGPoint(x: 0,y: 0), size: psize)
        lenOfMission = mission!.missions.count
        
  
        startSubMission(mission!.missions[0])
        
        
        
        var tplayer = Player(hp: 1000)
        self.player = tplayer
        self.infoLayer = InfoLayer(position: CGPoint(x: 0,y: 640), player: tplayer, gameScene: self)
        
        
        backgroundColor = SKColor.whiteColor()
      
        
        
        initControlLayer()
 
        //self.addChild(controlLayer)
        self.addChild(infoLayer!)
        self.addChild(tapTimer)
        self.addChild(longTapTimer)
 
        
        physicsWorld.contactDelegate = self
       
 
    }


    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

/*
    func initControlLayer() -> (){
        controlLayer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height / 2) )
        controlLayer.fillColor = SKColor.blueColor()
        controlLayer.zPosition = 10000
        
*/
    func initControlLayer() -> (){
        let UIN = UINode(position: CGPoint(x: self.size.width/2,y: 0), parent:self)
        controlLayer = UIN
        UIN.zPosition=100000
        self.addChild(UIN)

    }
//-------------------- start Sub-Mission --------------------
    func startSubMission(subMission : SubMission){
        if gameLayer != nil{
            var pPos = self.gameLayer!.position
            self.gameLayer!.deleteSelf()
            gameLayer!.removeFromParent()
            gameLayer = GameLayer(subMission: subMission, gameScene: self)
            gameLayer!.position = pPos
        }else{
            let ph: CGFloat = size.height / 2
            let pPos = CGPoint(x: 0, y : ph)
            gameLayer = GameLayer(subMission: subMission, gameScene: self)
            gameLayer!.position = pPos
        }
        self.addChild(gameLayer!)
        
        //var newY = gameLayer!.position.y + movement
        let diff = gameArea!.height - playRect!.size.height
        let lowerBound = playRect!.origin.y - diff
        gameLayer!.position = CGPoint(x:0 , y:lowerBound)
        controlLayer?.position = CGPoint(x: self.size.width/2, y: 0)
        print (gameArea!.origin.y)
        print(lowerBound)
        
        self.currentStage = GameStage.Temp
        gameLayer!.runAction(SKAction.moveToY(playRect!.origin.y, duration: 2.5), completion: {
            () -> () in
                self.createMissionLabel(self.currentMission + 1)
                self.startSuperpositionPhase()
            
            })
        
        
      
    }
    
//-------------------- phys detect-----------------------------------------
    func didBeginContact(contact: SKPhysicsContact) {
     //   ////print("contact")
        ////print ("A : \(contact.bodyA.node!.name) #\(unsafeAddressOf(contact.bodyA.node!)) , B : \(contact.bodyB.node!.name) #\(unsafeAddressOf(contact.bodyB.node!))")
       // self.contactQueue.append(contact)
       //     ////print (contact.contactPoint)
     //////print(contact.contactNormal)
        
        if ( tryFindEnergyPacket(contact.bodyA.node, other: contact.bodyB.node, contact: contact) == true){
            return
        }else if (tryFindEnergyPacket(contact.bodyB.node, other: contact.bodyA.node, contact: contact) == true){
            return
        }
        
        
        
    }
    
    func validateIncidence (packet : EnergyPacket, _ medium : Medium,_ contact: ContactInfo, exit: Bool) -> Bool{
        if (packet.deleted){
            return false
        }
        ////print(medium.path)
        ////print(CGPathContainsPoint(medium.path, nil,CGPoint(x: 0, y: 0) , true))
        //print (contact.contactNormal)
        var conPos = medium.getSprite()!.convertPoint(packet.sprite!.position, fromNode: gameLayer!)
        // //print(CGPathContainsPoint(medium.path, nil,temp , true))
        var toward: CGVector = contact.contactPoint - (packet.sprite!.position + gameLayer!.position)
        toward.normalize()
        var contactPt = medium.getSprite()!.convertPoint(contact.contactPoint, fromNode: self)
        
      
       
        if (exit){
            if (CGPathContainsPoint(medium.path, nil, conPos, true)==false){ //some fix
                contact.contactNormal = -1 * contact.contactNormal
            }
        }else{
            if (CGPathContainsPoint(medium.path, nil, conPos, true)==true){ //some fix
                contact.contactNormal = -1 * contact.contactNormal
            }
        }
        var product = contact.contactNormal.dot(packet.direction)
        if (product >= 0 ){
            return false
        }else{
            return true
        }
       
        
      
        return false
    }
    
    var contactMap: [EnergyPacket: ContactContainer] = Dictionary<EnergyPacket, ContactContainer>()
    
    func tryFindEnergyPacket(sk : SKNode?, other other : SKNode?, contact nativeContact :SKPhysicsContact) -> Bool {
        var contact = ContactInfo(nativeContact)
        var packet: EnergyPacket? = nil
        if (sk is HasGameObject){
            let has = sk as! HasGameObject?
            ////print ("gameObject : \(has?.gameObject)")
            if ( has?.gameObject is EnergyPacket){
                packet = has!.gameObject as! EnergyPacket
        
                
                
                if (other!.name == GameObjectName.GameBoundary.rawValue){ // out of area
                    //out of bound
                    if (contactMap[packet!] != nil){
                        contactMap[packet!]!.outOfArea = true
                    }else{
                         let temp2 = ContactContainer()
                        temp2.outOfArea = true
                        contactMap[packet!] = temp2
                        
                    }
                    return true
                    
                }
                if (other is HasGameObject){
                    let has2 =  (other as! HasGameObject)
                    if ( has2.gameObject is Medium){
                        let medium = has2.gameObject as! Medium
                        if (contactMap[packet!] != nil){
                            
                            if (contactMap[packet!]!.mediumContacted.contains(medium)){
                                return true
                            }
                            
                            if (packet?.containsMedium(medium) == true){ //exit
                                if validateIncidence(packet!, medium, contact, exit: true){
                                    contactMap[packet!]!.mediumContacted.insert(medium)
                                    contactMap[packet!]!.exit.append((medium,contact))
                                                                    }
                            }else{
                                if validateIncidence(packet!, medium, contact, exit: false){
                                    contactMap[packet!]!.mediumContacted.insert(medium)
                                    contactMap[packet!]!.enter.append((medium,contact))
                                }
                            }
                        }else{
                            let temp2 = ContactContainer()
                            if (packet?.containsMedium(medium) == true){ //exit
                                if (validateIncidence(packet!, medium, contact, exit: true)){
                                    temp2.mediumContacted.insert(medium)
                                    temp2 .exit.append((medium,contact))
                                    
                                }
                            }else{
                                if (validateIncidence(packet!, medium, contact, exit: false)){
                                    temp2.mediumContacted.insert(medium)
                                    temp2.enter.append((medium,contact))
                                }
                                
                            }
                           // temp2.enter.append((other!,contact))
                            contactMap[packet!] = temp2
                            
                        }
                        return true
                    }
                }
            }
        }

        return false
    }
    
    
    
    func didEndContact(contact: SKPhysicsContact) {
   
    }
    
    
    
    
    func handleContact(){
        
        for (packet, wrapper) in contactMap{
            
            
            if (wrapper.outOfArea == true){
                
                packet.deleteSelf()
                continue
            }
            
           
            var froms = Set<Medium>()
            var tos = Set<Medium>()
            var contacts = [Medium : ContactInfo]()
           
            
            
            
            
            for (from , contact) in wrapper.exit {
                froms.insert(from)
                contacts[from] = contact
            }
            for (to, contact) in wrapper.enter{
                tos.insert(to)
               // var conPos = to.getSprite()!.convertPoint(packet.sprite!.position, fromNode: gameLayer!)
                //print("pos:\(CGPathContainsPoint(to.path, nil, conPos, true))  normal: \(contact.contactNormal) " )
                contacts[to] = contact
            }
            
            packet.changeMedium(from: froms, to: tos, contact: contacts)

        }
        contactMap.removeAll()
     
    }
    
//---------------------------------------
    
    func removeGameObjectFromList (var ls: [GameObject], obj :GameObject) ->(){
        for i in 0...(ls.count - 1){
            if (ls[i] === obj){
                ls.removeAtIndex(i)
                return
            }
        }
    }
    
    
    func addObjectsToNode (parent : SKNode, _ children : [GameObject])->(){
        for obj in children{
            if let temp = obj.getSprite(){
                parent.addChild(temp)
            }
        }
    }
    
//----------------------touching --------------------------
    var touching : Bool = false
    var touchType : TouchType? = nil
    var prevTouchPoint : CGPoint? = nil

    var isTap : Bool = false
    var tapTimer : SKNode = SKNode()
    var longTapTimer : SKNode = SKNode()
    var pressedDestObject : DestructibleObject? = nil
    var prevPressedObj : Clickable? = nil
    var destHpBarSize : CGSize = CGSize(width: 50, height: 10)
    var destHpBar : HpBar? = nil
    var clearUpNodes = Set<SKNode>()
    var pressedSkill : Skill? = nil
    var dragSkillObj : GameObject? = nil
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
        // print("long press on obj")
        var sprite = pressedDestObject!.getSprite()!
        // print(sprite.position)
        var hpbar = HpBar.createHpBar(CGRect(origin: convertTouchPointToGameAreaPoint(CGPoint(x: prevTouchPoint!.x - 25 , y: prevTouchPoint!.y + 20)) , size: destHpBarSize), max: pressedDestObject!.originHp, current: pressedDestObject!.hp, belongTo: pressedDestObject!)
        gameLayer?.addChild(hpbar)
        destHpBar = hpbar
        //clearUpNodes.insert(hpbar)
    }
    
    
    func convertTouchPointToGameAreaPoint( point: CGPoint) -> CGPoint{
        var res : CGPoint = point - gameLayer!.position
        return res
    }
    

    var dragVelocity : CGFloat = 0
    var dragging : SKNode?=nil
    var timerStarted=false

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if touches.count > 0 {//drag
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
                    print(CGRectContainsPoint(gameLayer.calculateAccumulatedFrame(), (touches.first?.locationInNode(gameLayer.parent!))!))
                }
                */

            }
        }

        
    }
    
    
    
    func timeOut(){
        print("timeOut")
        let resultWave=(self.childNodeWithName("UINode") as! UINode).drawSuperposition()
        spawnWave(resultWave.getAmplitudes())
        timerStarted = false
        clearTouch()
    }
    var waveData:[CGFloat]?
    func spawnWave(waveData:[CGFloat]){
        self.waveData=waveData
        
        for i in 0...waveData.count-1{
            if (i % 8 != 0) {continue}
           // let p1 = NormalEnergyPacket(abs(waveData[i])*40+1000, position: CGPoint(x: 37.5 + Double(i), y: 50), gameScene :self)
            //p1.direction = CGVector(dx: 0, dy: 1)
            //p1.gameLayer = gameLayer
            //p1.pushBelongTo(gameLayer!.background!)
            //gameLayer!.addGameObject(p1)
            
            
            
            //var tempx: CGFloat = (self.size.width - CGFloat(20)) / 20.0
            //tempx = tempx * CGFloat(i) + 10
            let p1 = NormalEnergyPacket(abs(waveData[i])*40+200, position: CGPoint(x: 37.5 + Double(i), y: 50), gameScene :self)
            p1.direction = CGVector(dx: 0, dy: 1)
            p1.gameLayer = gameLayer
            p1.pushBelongTo(gameLayer!.background!)
            for obj in gameLayer!.attackPhaseObjects{
                if obj is Medium{
                    var medium = obj as! Medium
                    var mediumPt = medium.getSprite()!.convertPoint(p1.getSprite()!.position, fromNode: gameLayer!)
                    if (CGPathContainsPoint(medium.path!, nil,mediumPt, true)){
                        p1.addBelong(medium)
                    }
                }
            }
            
            gameLayer!.addGameObject(p1)
        }
        startAttackPhase()
        
        
        
        

    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touching == false) {return}
        if (self.touchType == nil) { return }
        if (touches.count > 0 ) {//drag
            if let touch = touches.first {

                 let touchDown = touch.locationInNode(self)
                checkPressing(touchDown)
            }
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touching){
            
            checkEndPress()
            
        }
        clearTouch()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        clearTouch()
    }
    
    
    
    func checkPressOn(touchDown :CGPoint,touches: Set<UITouch>){
        
        
        if (CGRectContainsPoint(CGRect(origin: gameLayer!.position, size: gameLayer!.calculateAccumulatedFrame().size), (touches.first?.locationInNode(gameLayer!.parent!))!)){
            touchType = TouchType.gameArea
            prevTouchPoint = touchDown
            if pressedSkill != nil{
                touchesBeganSkill(prevTouchPoint!)
                return
            }else{
                for gameObject in (gameLayer?.attackPhaseObjects)!{ // find GameObject pressed
                    if gameObject is DestructibleObject{
                        var medium = gameObject as! DestructibleObject
                        var mediumPt = medium.getSprite()!.convertPoint(touchDown, fromNode: self)
                        if (CGPathContainsPoint(medium.path!, nil, mediumPt, true)){
                            pressedDestObject = medium
                        }
                    }
                }
                
            
              
            }
        }else if currentStage == GameStage.Superposition && CGRectContainsPoint(controlRect!, touchDown){ // control Layer
            touchType = TouchType.controlArea
            prevTouchPoint = touchDown
            for c in (self.childNodeWithName("UINode")?.childNodeWithName("UIWaveButtonGroup")!.children)!
            {
                //print(c.description)
                //print(CGRectContainsPoint(c.frame, (touches.first?.locationInNode(c.parent!))!))
                //check clicked on Button
                if (CGRectContainsPoint(c.calculateAccumulatedFrame(), (touches.first?.locationInNode(c.parent!))!))
                {
                    //do action
                    touchType = TouchType.waveButton
                    dragging=c
                    break
                }
            }
            for c in (self.childNodeWithName("UINode")?.childNodeWithName("UICharacterButtonGroup")!.children)!
            {
                //print(c.description)
                //print(CGRectContainsPoint(c.frame, (touches.first?.locationInNode(c.parent!))!))
                //check clicked on Button
                if (CGRectContainsPoint(c.calculateAccumulatedFrame(), (touches.first?.locationInNode(c.parent!))!))
                {
                    //do action
//                    viewController!.changeScene(GameViewController.Scene.TeamScene)
                    touchType = TouchType.button
                    prevPressedObj = c as! Clickable
                    break
                }
            }
        }
        //button
        var tempBtn  = infoLayer?.checkClick(touchDown)
        if tempBtn != nil{
            touchType = TouchType.button
            prevPressedObj  = tempBtn!
        }
        
        
        
    }

    
    func checkPressing(touchDown :CGPoint){
        let diff :CGVector =  prevTouchPoint! - touchDown
       // print(diff)
        let moveY = diff.dy * 2
        if (touchType! == TouchType.gameArea){
            
            prevTouchPoint  = touchDown
            if (pressedSkill != nil && touchesMovedSkill(touchDown) == false){
                return
            }
            
            
            scrollLayers(-moveY)
            dragVelocity = (-moveY)
            if pressedDestObject != nil { //long pressed object
                var mediumPt = pressedDestObject!.getSprite()!.convertPoint(touchDown, fromNode: self)
                if (CGPathContainsPoint(pressedDestObject!.path!, nil, mediumPt, true) != true){
                    pressedDestObject = nil
                    destHpBar?.removeFromParent()
                    destHpBar = nil
                }
                
            }
            
        }else if(touchType! == TouchType.waveButton){
            if(!timerStarted){
               // let timer = NSTimer(timeInterval: 5.0, target: self, selector: "timeOut", userInfo: nil, repeats: false)
                //NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
                var timerNode = SKNode()
                self.addChild(timerNode)
                timerNode.runAction(SKAction.sequence([SKAction.waitForDuration(5), SKAction.removeFromParent()]),completion: self.timeOut)
                print("start timer")
                timerStarted=true
            }
            prevTouchPoint  = touchDown
           // print(diff.dx)
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
    func checkEndPress (){
        if self.currentStage == GameStage.Superposition{
            
            if touchType == TouchType.gameArea{
                if (pressedSkill != nil && touchesEndedSkill(prevTouchPoint!) == false){
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
    
    
    func touchesBeganSkill(touchDown :CGPoint){
        if (pressedSkill is PlacableSkill){
            let temp =  pressedSkill as! PlacableSkill
            var gameObj = temp.createGameObj(gameLayer!.maxZIndex, gameScene: self)
            gameObj.getSprite()!.runAction(SKAction.fadeAlphaTo(0.3, duration: 0))
            gameObj.getSprite()!.position = touchDown
            gameLayer?.addGameObject(gameObj)
            dragSkillObj = gameObj
        }else if (pressedSkill is TargetSkill){
            
        }
    }
    func touchesMovedSkill(touchDown :CGPoint) -> Bool{
        if (pressedSkill is PlacableSkill){
            if (CGRectContainsPoint(playRect!, touchDown)){
               
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
    
    func touchesEndedSkill (touchDown :CGPoint) -> Bool{
        if (pressedSkill is PlacableSkill){
            if (CGRectContainsPoint(playRect!, touchDown)){
                
                dragSkillObj?.getSprite()!.runAction(SKAction.moveTo(convertTouchPointToGameAreaPoint(touchDown), duration: 0))
                dragSkillObj?.getSprite()!.runAction(SKAction.fadeAlphaTo(1, duration: 0))
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
    
    
    func scrollLayers(movement : CGFloat){
        //print(gameArea)
        
        var newY = gameLayer!.position.y + movement
        let diff = gameArea!.height - playRect!.size.height
        let lowerBound = playRect!.origin.y - diff

        
        if newY < lowerBound{
            newY = lowerBound
        }else if newY > playRect!.origin.y {
            newY = playRect!.origin.y
        }
        //gameLayer.position.y = newY
        gameLayer!.runAction(SKAction.moveToY(newY, duration: 0))
        controlLayer!.scroll(0, y: newY-self.size.height/2)

    }
    

    func clickOnControlLayer(){
        //prevPressObj ??
        
        // find skill
        
        //temp ------
   
        if (pressedSkill != nil){
            pressedSkill = nil
            return
        }
        
        
        var choseSkill = ConvexLenSkill()
        
        //check
        if (choseSkill is SimpleSkill){
            choseSkill.perform(self)
        }else{
            pressedSkill = ConvexLenSkill()
        }
    
        
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

    }
    
    func tempCreatePacket(){
        for i in 0...20{
            var tempx: CGFloat = (self.size.width - CGFloat(20)) / 20.0
            tempx = tempx * CGFloat(i) + 10
            let p1 = NormalEnergyPacket(1000, position: CGPoint(x: tempx , y: 1), gameScene: self)
            p1.direction = CGVector(dx: 0, dy: 1)
            p1.gameLayer = gameLayer
            p1.pushBelongTo(gameLayer!.background!)
            for obj in gameLayer!.attackPhaseObjects{
                if obj is Medium{
                    var medium = obj as! Medium
                    var mediumPt = medium.getSprite()!.convertPoint(p1.getSprite()!.position, fromNode: gameLayer!)
                    if (CGPathContainsPoint(medium.path!, nil,mediumPt, true)){
                        p1.addBelong(medium)
                    }
                }
            }
            
            gameLayer!.addGameObject(p1)
            
        }
    }
    
    
    var countFrame :Int = 0
    var counter:Int=0
    override func update(currentTime: CFTimeInterval) {
        
        switch (currentStage){
        case .Attack:
            
            handleContact()
            attackPhaseUpdate(currentTime)
           
            break
        default:
            break
        }

        //////print(currentTime - lastTimeStamp)
        if (countFrame % 30 == 0 && countFrame < 1000){
            switch (currentStage){
            case .Attack:
                
                if (waveData != nil){
                 /*
                    var tempx: CGFloat = (self.size.width/2)
                    let p1 = NormalEnergyPacket( abs(waveData![counter])*40+1000, position: CGPoint(x: 37.5 + Double(counter), y: 50), gameScene :self)
                    p1.direction = CGVector(dx: 0, dy: 1)
                    p1.gameLayer = gameLayer
                    p1.pushBelongTo(gameLayer!.background!)
                    gameLayer!.addGameObject(p1)
                    counter=(counter+1)%300
*/
                }

                break
            default:
                break
            }
            
        }
        
        //smooth scrolling
        if ((dragVelocity != 0) && (touching == false))
        {
            scrollLayers(dragVelocity)
            dragVelocity *= 0.9
            if (abs(dragVelocity) < 5) {dragVelocity = 0}
        }

      
        
        countFrame += 1
        if ((currentTime - lastTimeStamp) > 1  ){
            
            /* Called before each frame is rendered */
            lastTimeStamp = currentTime
        }
       
    
        
    }

    
//----------- phase change -----------------------------
    func startEnemyPhase (){
        self.currentStage = GameStage.enemy
        gameLayer!.enemyDoAction()
        print("start enemy phase")
        
    }
    func startCheckResult(){
        self.currentStage = GameStage.Checking
        if gameLayer!.checkResult() == false {
            startEnemyPhase()
        }
    }
    
    func startSuperpositionPhase(){
        self.currentStage = GameStage.Superposition
        print("start superposition")
        numRounds += 1
    }
    
    func startAttackPhase(){
        self.currentStage = GameStage.Attack
        print("start attack phase")
        
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
        
        if (currentMission >= mission?.missions.count){
            currentStage = GameStage.Complete
            print("complete Mission")
            gameLayer!.fadeOutAll({
                () -> () in
                self.resultUI = ResultUI.createResultUI(CGRect(origin: CGPoint(x: 30,y: 100), size: CGSize(width: 300, height: 550)), gameScene : self)
                self.addChild(self.resultUI!)
                
                //numRounds = 20
                self.resultUI!.showResult({
                    () -> () in
                    print("finished")
                })
            
                return

                
            })
            
            return
           
        }
        currentStage = GameStage.Temp
        
        //self.createMissionLabel(self.currentMission + 1)
        gameLayer!.fadeOutAll({
            () -> () in
           
            
            self.startSubMission((self.mission?.missions[self.currentMission])!)

        })
        
    }
    func createMissionLabel(current : Int){

        createFlashLabel("Mission \(current)/\(mission!.missions.count)")

    
    }
    func createFlashLabel(text : String){
        var label = SKLabelNode(text: text)
        label.position = CGPoint(x: self.size.width / 2, y: 500)
        label.zPosition = 10000
        label.fontName = "Helvetica"
        var seq : [SKAction] = [SKAction.waitForDuration(2) , SKAction.fadeOutWithDuration(0.5)]
        
        self.addChild(label)
        label.runAction(SKAction.sequence(seq), completion :
            { () -> () in
                label.removeFromParent()
        })
        
        
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




