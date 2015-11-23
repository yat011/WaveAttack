//
//  WaveGeneratorUI.swift
//  WaveAttack
//
//  Created by yat on 22/11/2015.
//
//

import Foundation
import SpriteKit

class WaveGeneratorUI : SKSpriteNode{
    var leftUI = SKSpriteNode()
    var rightUI = SKSpriteNode()
    var cropNode = SKCropNode()
    var cropMaskNode = SKSpriteNode()
    var cropBallNode = SKCropNode()
    var ballMask: SKSpriteNode? = nil
    var gunNode = SKSpriteNode()
    let closeSize = CGSize(width: 50, height: GameScene.current!.playerAttackArea.height)
    let closePlayerSize = CGSize(width: 40, height: GameScene.current!.playerAttackArea.height)
    let numOfPhysDiv = 30
    let closeLeftPt = CGPoint(x: -12.5, y: 0)
    let closeRightPt = CGPoint(x: 12.5, y: 0)
    var timer = FrameTimer(duration: 1)
    let attackTexture = SKTexture(imageNamed: "attack")
    let MoveTime:CGFloat = 1
    let colors = [SKColor.cyanColor(), SKColor.yellowColor(), SKColor.purpleColor(),SKColor.redColor(),SKColor.greenColor(),SKColor.whiteColor(),SKColor.blackColor()]
    let blendingFactor = 0.6.f
    var atkUIs :[ChargingPowerBallUI] = []
    weak var gameScene : GameScene? = nil
    var playerArea : SKSpriteNode? = nil
    convenience init(){
        self.init(texture:nil)
        let gameScene = GameScene.current!
        self.gameScene = gameScene
       var texture = SKTexture(imageNamed: "alien1")
        var leftTexture = SKTexture(rect: CGRect(x: 0, y: 0, width: 0.5, height: 1), inTexture: texture)
        var rightTexture = SKTexture(rect: CGRect(x: 0.5, y: 0, width: 0.5, height: 1), inTexture: texture)
        let singleSize = CGSize(width: closeSize.width/2 , height: closeSize.height)
        leftUI.texture = leftTexture
        leftUI.size = singleSize
        rightUI.texture = rightTexture
        rightUI.size = singleSize
        
        leftUI.position = closeLeftPt
        rightUI.position = closeRightPt
        self.addChild(leftUI)
        self.addChild(rightUI)
        cropMaskNode.size=CGSize(width: 0, height: 20)
        cropMaskNode.color=SKColor.redColor()
        cropNode.maskNode = cropMaskNode
        gunNode.texture = SKTexture(imageNamed: "gun")
        gunNode.size = CGSize(width: gameScene.playerAttackArea.width, height: 200)
        gunNode.position = CGPoint(x: 0, y: -80)
        cropNode.addChild(gunNode)
        self.addChild(cropNode)
        var temp = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 0, height: 300))
        temp.position = CGPoint(x: 0, y: 150)
        ballMask = temp
        cropBallNode.maskNode = temp
        self.addChild(cropBallNode)
        self.zPosition = GameLayer.ZFRONT + 2
        initPlayerDamageArea()
        
    }
    func initPlayerDamageArea(){
        
        var playerArea = SKSpriteNode()
        playerArea.size = closePlayerSize
        playerArea.physicsBody=createPlayerPhysics(closePlayerSize)
        playerArea.position = CGPoint(x: 0, y: 0 )
        // gameScene!.addChild(playerArea)
        self.playerArea = playerArea
        self.addChild(playerArea)
    }
    func createPlayerPhysics (size : CGSize)-> SKPhysicsBody{
        let phys = SKPhysicsBody(rectangleOfSize: size)
        phys.dynamic = false
        phys.categoryBitMask = CollisionLayer.PlayerHpArea.rawValue
        phys.collisionBitMask = 0
        phys.contactTestBitMask = 0
        return phys
    }
    var animateTimer = FrameTimer(duration: 1)
    func animateStoringPower(maxAtk : Int, maxTime : CGFloat){
        animateTimer.reset()
        let times = (maxTime / maxAtk.f)
        var current = 0
        animateTimer.setTargetTime(times)
        animateTimer.addToGeneralUpdateList()
        var f : (()->()) = {
            Void in
            var node = self.createAtkUI(times, currentIndex: current)
            self.atkUIs.append(node)
            node.startCharging()
            self.cropBallNode.addChild(node)
            current++
            if current == maxAtk{
                self.animateTimer.stopTimer()
                self.animateTimer.removeFromGeneralUpdateList()
                return
            }
            
        }
        f()
        animateTimer.repeatTimer(f)
        
    }
    func stopAnimateStoringPower(){
       animateTimer.stopTimer()
        
        if atkUIs.count > 0 && !atkUIs.last!.complete {
           var node = atkUIs.removeLast()
            node.discharge({
                Void in
                node.removeFromParent()
            })
        }
    }
    func createAtkUI(time : CGFloat, var currentIndex : Int) -> ChargingPowerBallUI{
        currentIndex = currentIndex%colors.count
       var ui = ChargingPowerBallUI(completeTime: time, color: colors[currentIndex])
        
        ui.size = CGSize(width: gameScene!.playerAttackArea.width, height: 120)
        ui.position = CGPoint(x: 0, y: -30)
        return ui
    }
    
   
    func close(){
        
        AnimateHelper.moveToTargetX(leftUI, targetX:  -12.5, time: MoveTime, completion: nil)
        AnimateHelper.moveToTargetX(rightUI, targetX: 12.5, time: MoveTime, completion: nil)
        AnimateHelper.resizeTo(cropMaskNode, targetSize: CGSize(width: 0, height: 20), time: MoveTime, completion: nil)
        AnimateHelper.resizeTo(ballMask!, targetSize: CGSize(width: 0, height: ballMask!.size.height), time: MoveTime, completion: nil)
        var progress = 0
        let targetW = closePlayerSize.width
        let oriW = playerArea!.size.width
        var divW = (targetW - oriW)/self.numOfPhysDiv.f
        var f : (()->())? = nil
        f = {
            Void in
            self.playerArea!.physicsBody = self.createPlayerPhysics(self.playerArea!.size)
            if progress == self.numOfPhysDiv{
                return
            }
            let targetSize  = CGSize(width: self.playerArea!.size.width + divW, height: 20)
            AnimateHelper.resizeTo(self.playerArea!, targetSize: CGSize(width: self.playerArea!.size.width + divW, height: 20), time: self.MoveTime/self.numOfPhysDiv.f, completion: f)
            progress++
            
        }
       f!()
        
    }
    func open(){
        AnimateHelper.moveToTargetX(leftUI, targetX: -gameScene!.playerAttackArea.width/2 + 5, time: MoveTime, completion: nil)
        AnimateHelper.moveToTargetX(rightUI, targetX: gameScene!.playerAttackArea.width/2 - 5, time: MoveTime, completion: nil)
        AnimateHelper.resizeTo(cropMaskNode, targetSize: CGSize(width: gameScene!.playerAttackArea.width, height: 20), time: MoveTime, completion: nil)
         AnimateHelper.resizeTo(ballMask!, targetSize: CGSize(width: 300, height: ballMask!.size.height), time: MoveTime, completion: nil)
        var progress = 0
        let targetW = gameScene!.playerAttackArea.width
        let oriW = playerArea!.size.width
        var divW = (targetW - oriW)/self.numOfPhysDiv.f
        var f : (()->())? = nil
        f = {
            Void in
            self.playerArea!.physicsBody = self.createPlayerPhysics(self.playerArea!.size)
            if progress == self.numOfPhysDiv{
                return
            }
            let targetSize  = CGSize(width: self.playerArea!.size.width + divW, height: 20)
            AnimateHelper.resizeTo(self.playerArea!, targetSize: CGSize(width: self.playerArea!.size.width + divW, height: 20), time: self.MoveTime/self.numOfPhysDiv.f, completion: f)
            progress++
            
        }
        f!()
        
    }
    func shoot(){
        if atkUIs.count > 0{
            var last = atkUIs.removeLast()
            last.shoot()
        }
    }
    

    
    
}