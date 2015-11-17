//
//  DestructibleObject.swift
//  WaveAttack
//
//  Created by yat on 14/9/2015.
//
//

import Foundation
import SpriteKit
import SceneKit
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
   // var absorptionRate :CGFloat = 0.05
   // var damageReduction :CGFloat = 0
    var scaleX: CGFloat  = 1
    var scaleY : CGFloat = 1
    var totDmg: CGFloat = 0
    var disappearThreshold: CGFloat = -10000
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
    
 //   override var path: CGPath? { get{ return _path}}
 //   var xDivMax: CGFloat  {get { fatalError(); return 1}} // for edge path
 //   var yDivMax: CGFloat {get {fatalError() ; return 1}}
 //   var _path : CGPath? = nil
 //   var moveRound : Int = 3
 //   var currentRound : Int = 0
    var hpBar : HpBar? = nil
    var hpBarRect :CGRect? = nil
//    var roundLabel : ActRoundLabel? = nil
//    var roundRect : CGRect? = nil
    var dead : Bool = false
    var originSize :CGSize? = nil
    var originPoint :CGPoint? = nil
//----crack UI---
    var crackUI :SKSpriteNode? = nil
    var cropCrackUI :SKCropNode? = nil
    var completeCrack :Bool = false
    var restitution : CGFloat  {get{return 0.1}}
//-----new
    class var breakTexture: [SKTexture]? {get {return nil} set(v){}} 
    class var breakRect: [CGRect]? { get{return nil}}
    class var oriTexture : SKTexture? {get{return nil}}
    class var score: [CGFloat] { get {return [10]}}
    var scoredIndex: Int = 0
    var sprites = [GameSKSpriteNode]()
    var attachedIndex = 0
    var sprite = SKSpriteNode()
    var joints = [SKPhysicsJoint]()
    //class var stopFunctioning : CGFloat { return 0.4}
    class var breakThreshold : [CGFloat]? {get{return nil}}
    var breakIndex  : Int? = nil
    class var density : CGFloat? { get{return nil}}
    var mass : CGFloat  = 0
    //var unionNode : GameSKSpriteNode = GameSKSpriteNode()
    //var unionJoint : SKPhysicsJoint? = nil
    var isFront = [SKNode:Bool]()
    var allPhysicsBody = [SKPhysicsBody]()
    var nodeJoints = [SKNode : [SKPhysicsJoint]]()
    var currentPos : CGPoint{
        get{
            return gameLayer.convertPoint(sprites[0].position, fromNode: sprites[0].parent!)
        }
    }
    
    static let GROUNED_LEN: CGFloat = 2
    
    
    static var hitTexture: [SKTexture]? = nil
    override func initialize(size: CGSize, position: CGPoint, gameScene: GameScene) {
        /*if getSprite() == nil {
            fatalError("sprite == nil")
        }
        self.gameScene = gameScene
        var sprite :GameSKSpriteNode = self.getSprite()! as! GameSKSpriteNode
        var originSize = sprite.size
       
        sprite.size = size
        self.originSize = size
        self.originPoint = position
        sprite.gameObject = self
         createPhysicsBody(originSize, targetSize: size)
         sprite.position = position
        
        var selfPos = getSprite()!.position
        var barpos = CGPoint(x: selfPos.x - self.getSprite()!.frame.width / 2 + 5 ,y: selfPos.y - self.getSprite()!.frame.height / 2  - 15)
        hpBarRect = CGRect(origin: barpos, size: CGSize(width: self.getSprite()!.frame.width - 10, height: 10))
        if (self is EnemyActable){
            
            roundRect = CGRect(x: selfPos.x + self.getSprite()!.frame.width / 2, y: selfPos.y - self.getSprite()!.frame.height / 2  - 15, width: 10, height: 13)
            roundLabel = ActRoundLabel.createActRoundLabel(roundRect!, enemy: self as! EnemyActable)
        }
*/
        
        
        self.originPoint = position
        self.originSize = size
        if self.dynamicType.breakTexture == nil{
           generateBreakTexture()
        }
        var i  = 0
        for texture in self.dynamicType.breakTexture!{
            var sprite = GameSKSpriteNode(texture: texture)
            sprite.name="dest"
            sprite.gameObject = self
            var clipRect  = self.dynamicType.breakRect![i]
            var tempSize = CGSize(width:  size.width * clipRect.width, height: size.height * clipRect.height)
            sprite.physicsBody = createPhysicsBody( tempSize)
            sprite.size = tempSize
            var tX = clipRect.origin.x * size.width + tempSize.width/2 - originSize!.width/2
            var tY = clipRect.origin.y * size.height + tempSize.height/2 - originSize!.height/2
            sprite.position = CGPoint(x: tX , y: tY)
            //sprite.physicsBody = createNoCollisionPhysicsBody(texture, size: size)
            
            allPhysicsBody.append(sprite.physicsBody!)
            isFront[sprite] = false
            attachedIndex++
            self.sprite.addChild( sprite)
            self.sprites.append(sprite)
            i++
        }
        
        
        /*
        for texture in textures!{
            
            var sprite = GameSKSpriteNode(texture: texture)
            sprite.name="dest"
            sprite.gameObject = self
            print(sprite.size)
            sprite.size =   size
            
            var tempTexture = GameScene.current?.view?.textureFromNode(sprite)
            print (tempTexture?.size())
            print(sprite.frame)
            print(sprite.size)
            sprite.position = CGPoint()
            sprite.physicsBody = createPhysicsBody(sprite.texture!, size: size)
            //sprite.physicsBody = createNoCollisionPhysicsBody(texture, size: size)
            allPhysicsBody.append(sprite.physicsBody!)
            isFront[sprite] = false
            attachedIndex++
            self.sprite.addChild( sprite)
            self.sprites.append(sprite)
            
        }
*/
       // var phys =  createPhysicsBody(bodies: allPhysicsBody)
        //unionNode.physicsBody = phys
        //unionNode.gameObject = self
       // isFront[unionNode] = false
       // sprite.addChild(unionNode)
    
        sprite.position = position
        var frame = sprite.calculateAccumulatedFrame()
         var barpos = CGPoint(x: position.x - frame.width / 2 + 5 ,y: position.y - frame.height / 2  - 15)
       // hpBarRect = CGRect(origin: barpos, size: CGSize(width: frame.width - 10, height: 10))
        hpBarRect = CGRect(origin: barpos, size: CGSize(width: 30, height: 10))
        mass = 0
        for each in sprites{
            mass += each.physicsBody!.mass
        }
        
    }
    override func getSprite() -> SKNode? {
        return sprite
    }
    func generateBreakTexture(){
        self.dynamicType.breakTexture = [];
        for each in self.dynamicType.breakRect!{
           self.dynamicType.breakTexture?.append(SKTexture(rect: each, inTexture: self.dynamicType.oriTexture!))
        }
    }
   
  /*
    func createPhysicsBody(texture: SKTexture ,size: CGSize) -> SKPhysicsBody {
        var phys = SKPhysicsBody (texture: texture, size: size)
        phys.categoryBitMask = CollisionLayer.Objects.rawValue
        phys.affectedByGravity = true
        phys.collisionBitMask = CollisionLayer.Objects.rawValue | CollisionLayer.Ground.rawValue | CollisionLayer.GameBoundary.rawValue
        phys.contactTestBitMask = CollisionLayer.Objects.rawValue | CollisionLayer.Ground.rawValue 
        phys.dynamic = true
        phys.usesPreciseCollisionDetection = true
        phys.density = self.dynamicType.density!
        phys.restitution = self.restitution
        return phys
    }
*/
    func createPhysicsBody(size: CGSize) -> SKPhysicsBody {
        var phys =  SKPhysicsBody(rectangleOfSize: size)
        phys.categoryBitMask = CollisionLayer.Objects.rawValue
        phys.affectedByGravity = true
        phys.collisionBitMask = CollisionLayer.Objects.rawValue | CollisionLayer.Ground.rawValue | CollisionLayer.GameBoundary.rawValue
        phys.contactTestBitMask = CollisionLayer.Objects.rawValue | CollisionLayer.Ground.rawValue
        phys.dynamic = true
        phys.usesPreciseCollisionDetection = true
        phys.density = self.dynamicType.density!
        phys.restitution = self.restitution
        return phys
    }

    override func afterAddToScene() {
        
        var keyPart = sprites[0]
       
        for var i = 0 ; i < sprites.count - 1; i++ {
            
            for var j = i + 1 ; j < sprites.count   ; j++ {
                var joint = createPhysicsJointFixed(sprites[i], bodyB: sprites[j], anchor: CGPoint())
                addJointToDict(sprites[i], joint: joint)
                addJointToDict(sprites[j],joint:joint)
                joints.append(joint)
            }
        }
        /*
        for part in  sprites{
            if part === keyPart{
                continue
            }
            joints.append(createPhysicsJointFixed(keyPart, bodyB: part, anchor: CGPoint()))
        }
*/
    //    unionJoint = (createPhysicsJointFixed(keyPart, bodyB: unionNode, anchor: CGPoint()))
     //   GameScene.current!.physicsWorld.addJoint(unionJoint!)
        fixedOnGround()
        
        for joint in joints{
            GameScene.current!.physicsWorld.addJoint(joint)
        }

        
    }
    func addJointToDict(node :SKNode, joint: SKPhysicsJoint){
        if nodeJoints[node] == nil { nodeJoints[node] = []}
        nodeJoints[node]!.append(joint)
    }
    
    func fixedOnGround(){
        
    }
    
    func isGrounded() -> Bool{
        let startPt = gameScene!.convertPoint(sprites[0].position, fromNode: sprite) + CGPoint(x: 0, y:  -sprites[0].size.height/2 + 0.5)
        let endPt = startPt + CGPoint(x: 0, y: -DestructibleObject.GROUNED_LEN)
        var phys = gameScene!.physicsWorld.bodyAlongRayStart(startPt, end: endPt)
        guard phys != nil else { return false}
      //  print(phys!.node!.name)
        if phys!.node!.name ==  Ground.Name{
            return true
        }else{
            return false
        }
        
    }
    func checkIfObjectAtFront(x : CGFloat)-> Bool{
        var dis  :CGFloat = 0
        var len :CGFloat = 0
        if x > 0 {
            dis = originSize!.width/2   - 0.5
            len = DestructibleObject.GROUNED_LEN
        }else{
            dis = -originSize!.width/2  + 0.5
            len = -DestructibleObject.GROUNED_LEN
            
        }
        let startPt = gameScene!.convertPoint(sprites[0].position, fromNode: sprite) + CGPoint(x:dis , y: 0)
        
        let endPt = startPt + CGPoint(x: len , y: 0)
        var phys = gameScene!.physicsWorld.bodyAlongRayStart(startPt, end: endPt)
        guard phys != nil else { return false}
        //print(phys!.node!.name)
        if sprites[0].physicsBody!.collisionBitMask & phys!.categoryBitMask  > 0{
           return true
        }
        return false
    }
    
    func checkOutOfArea(){
        for var i = sprites.count - 1 ; i >= 0 ; i-- {
            var each = sprites[i]
            let rect = CGRect(origin:  sprite.position  + each.frame.origin, size: each.frame.size)
            if (CGRectContainsRect(gameLayer.validArea!, rect) == false){
                each.removeFromParent()
                nodeJoints[each]?.removeAll()
                sprites.removeAtIndex(i)
            }
        }
        if sprites.count == 0{
            if self.dead == false{
                self.die()
            }
           gameLayer.removeGameObject(self)
        }
    }

    override func update() {
        
    //    if (totDmg != 0 && animating == false){
   //         shaking()
    //    }
   /*     totDmg = 0
        if (hp < disappearThreshold){
            //destory self and inside packet
            destorySelf()
        }
*/
        for each in sprites{
            if each.gameObject == nil{
             //   print(each.position)
              //  print(each.physicsBody!.velocity)
              //  print(each.physicsBody!.angularVelocity)
            }
        }
        
        guard self.dynamicType.breakThreshold != nil else{return }
        if breakIndex == nil{
            breakIndex = self.dynamicType.breakThreshold!.count - 1
        }
        guard breakIndex! >= 0 else { return }
        if hp/self.originHp < self.dynamicType.breakThreshold![breakIndex!]{
          //  if unionNode.physicsBody!.resting == false{
           //     return
          //  }
            breakIndex!--
            var  node = sprites[--attachedIndex]
            mass -= node.physicsBody!.mass
           node.gameObject = nil
            
           var joints = nodeJoints[node]!
            
            for var i = 0 ; i < joints.count; i++ {
                var joint = joints[i]
                GameScene.current!.physicsWorld.removeJoint(joint)
            }
            nodeJoints[node]!.removeAll()
           // GameScene.current!.physicsWorld.removeJoint(joints.removeLast())
            //node.physicsBody! = createNoCollisionPhysicsBody(node.texture!, size: originSize!)
            changeToFront(node.physicsBody!)
           // SKEmitterNode(fileNamed: "Smoke.sks")
           jointBroken(node)
        }
        
        
        
        
    }
    
    func jointBroken (node : SKSpriteNode){
        
    }
    
    
    func updateUnionNode(){
        /*
        unionNode.physicsBody = createPhysicsBody(bodies: allPhysicsBody)
        
        if isFront[unionNode]! == true {
            changeToFront(unionNode.physicsBody!)
        }
        GameScene.current!.physicsWorld.removeJoint(unionJoint!)
        unionJoint = createPhysicsJointFixed(sprites[0], bodyB:unionNode , anchor: CGPoint())
        GameScene.current!.physicsWorld.addJoint(unionJoint!)
*/
    }
    
    func changeToFront(phys :SKPhysicsBody){
        isFront[phys.node!] = true
        phys.categoryBitMask = CollisionLayer.FrontObjects.rawValue
        phys.collisionBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue | CollisionLayer.GameBoundary.rawValue
        phys.contactTestBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue
        phys.node!.zPosition = GameLayer.ZFRONT
    }
    
   /*
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
        
        var phys = SKPhysicsBody (edgeLoopFromPath: path)
        
        phys.usesPreciseCollisionDetection = true
        phys.collisionBitMask = 0x0
        //phys.affectedByGravity = false
        phys.categoryBitMask = CollisionLayer.Medium.rawValue
         self.physContactSprite.physicsBody = phys
        //getSprite()!.physicsBody = phys
               // var anPoint = tempSprite.anchorPoint
        
        var temp = getSprite() as! GameSKSpriteNode
        temp.gameObject = self
        //var shape = SKShapeNode(path: _path!)
        //var texture = GameViewController.skView!.textureFromNode(shape)
        phys = SKPhysicsBody(texture: temp.texture!, size: temp.size)
        phys.categoryBitMask = CollisionLayer.Objects.rawValue | CollisionLayer.Ground.rawValue
        phys.affectedByGravity = true
        phys.collisionBitMask = CollisionLayer.Objects.rawValue | CollisionLayer.Ground.rawValue
        phys.contactTestBitMask = CollisionLayer.Objects.rawValue | CollisionLayer.Ground.rawValue
        phys.dynamic = true
      //  phys.usesPreciseCollisionDetection = true
        getSprite()!.physicsBody = phys
        
        
        
        
        self.getSprite()!.addChild(self.physContactSprite)
    }
    */
    func drawPath(path: CGMutablePath, offsetX : CGFloat, offsetY: CGFloat){
        fatalError("drawPath not implemented")
    }
    
    
    
    
    
    
   
    
  

    
    func impulseDamage(impulse : CGFloat, contactPt: CGPoint){
        let threshold:CGFloat = 10 *  mass
        
        guard impulse > threshold  else{
            return
        }
        
        var damage = (impulse - threshold)  * (1 - restitution) * 0.8
        
        
        changeHpBy(-damage)
        
        
        
    }
    func animeHit( contactPt : CGPoint){
        if DestructibleObject.hitTexture == nil{
            var sheet = SKTexture(imageNamed: "Hit")
            DestructibleObject.hitTexture = []
            for var i in 0..<4{
                DestructibleObject.hitTexture!.append(SKTexture(rect: CGRect(origin: CGPoint(x: CGFloat(i) * 0.25, y: 0), size: CGSize(width: 0.25, height: 1)), inTexture: sheet))
                
            }
        }
        var sheet = SKTexture(imageNamed: "Hit")
        var animateNode = SKSpriteNode()
        //self.getSprite()!.parent!.addChild(animateNode)
        //  animateNode.position = CGPoint(x: , y: )
        print(contactPt)
      //  self.gameScene = GameScene.current!
        GameScene.current!.gameLayer!.addChild(animateNode)
        animateNode.position = gameScene!.gameLayer!.convertPoint( contactPt, fromNode : gameScene!)
        animateNode.zPosition = 10000
        animateNode.size = CGSize(width: 32.5, height: 40)
        
        animateNode.runAction( SKAction.animateWithTextures(DestructibleObject.hitTexture!, timePerFrame: 0.1, resize: false, restore: false),completion:{
            () -> ()in
            animateNode.removeFromParent()
        })
        
    }
    
    func changeHpBy(delta : CGFloat){
        _hp = hp + delta
        if (hp < 0 && dead == false){
            die()
        }
        triggerEvent(GameEvent.HpChanged.rawValue)

    }
    
    
   
    
   var prevAction :SKAction? = nil
    var animating : Bool = false
    var prevCrackAction :SKAction? = nil
    func expandComplete(){
        
        getSprite()!.runAction(prevAction!.reversedAction(), completion: completeShake)
        guard prevCrackAction != nil else {return}
        crackUI?.runAction(prevCrackAction!.reversedAction())
        
        cropCrackUI?.maskNode!.runAction(prevCrackAction!.reversedAction())
    }
    func completeShake(){
        animating = false
    }
    
    func shaking(){
        
   /*
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
        if (completeCrack){
            //prevCrackAction = SKAction.resizeToWidth((1 + prevScale) * oriSize.width, height: (1 + prevScale) * oriSize.height, duration: 0.1)
            prevCrackAction = prevAction
            crackUI?.runAction(prevCrackAction!)
           // SKAction.resizeToWidth((1 + prevScale) * oriSize.width, height: (1 + prevScale) * oriSize.height, duration: 0.1)
            cropCrackUI?.maskNode!.runAction(prevCrackAction!)
        }
        scaled = true
        */
    }
    
  
    
    func destorySelf(){
        super.deleteSelf()
     
        self.getSprite()!.removeAllChildren()
        self.gameScene!.gameLayer!.removeGameObject(self)
        if hpBar != nil{
            hpBar!.removeFromParent()
            hpBar = nil
        }
       
        
        
        
        
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
    
// ------- crack/dead-------
    func die (){
        dead =  true
    
        /*
        var crop = SKCropNode()
        var temp = SKSpriteNode()
        temp.texture = (getSprite()! as! SKSpriteNode).texture
        temp.size = originSize!
        //temp.runAction(SKAction.resizeToWidth(originSize!.width, height: originSize!.height, duration: 1))
        crop.maskNode = temp
        
        
        var crackUI = SKSpriteNode()
        var aniTexture : [SKTexture] = []
        //var total = originSize!.width * originSize!.height / 1000
       // print(total)
        for var i = 1 ; i <= 8 ; ++i {
            var tempSize = CGSize(width: CGFloat(i) * originSize!.width / 8, height: CGFloat(i) * originSize!.height/8)
            aniTexture.append(SKTexture(image: TextureTools.createTiledTexture("crack.png", tiledSize: CGSize(width: 50, height: 50), targetSize: tempSize)))
        }
        
        //crackUI.texture = SKTexture(image: TextureTools.createTiledTexture("crack.png", tiledSize: CGSize(width: 50, height: 50), targetSize: originSize!))
        crackUI.size = CGSize(width: 5, height: 5)
       // crackUI.runAction(SKAction.resizeToWidth(originSize!.width, height: originSize!.height, duration: 1))
        crackUI.runAction(SKAction.animateWithTextures(aniTexture, timePerFrame: 0.2, resize: true, restore: false),completion:{
            ()->() in
            self.completeCrack = true
            
            })
        // SKAction.an
        self.crackUI = crackUI
        self.cropCrackUI = crop
        crop.addChild(crackUI)
        crop.zPosition = getSprite()!.zPosition + 1
        self.getSprite()!.addChild(crop)
*/
        scoredIndex = 0
        triggerEvent(GameEvent.Scored.rawValue)
        triggerEvent(GameEvent.Dead.rawValue)
        
    }
    
    override func syncPos() {
        super.syncPos()
       
    }
    
    func createPhysicsJointPin(bodyA: SKNode,bodyB : SKNode, anchor:CGPoint) -> SKPhysicsJointPin{
        var localPt = CGPoint(x: anchor.x * originSize!.width, y: anchor.y * originSize!.height)
        
        var pos =  GameScene.current?.convertPoint(anchor, fromNode: bodyA.parent!)
        print(pos)
        var joint = SKPhysicsJointPin.jointWithBodyA(bodyA.physicsBody!, bodyB: bodyB.physicsBody!, anchor: pos!)
        joint.shouldEnableLimits = true
        joint.lowerAngleLimit = -0.2
        joint.upperAngleLimit = 0.5
        joint.frictionTorque =  0.5
        return joint
    }
    func createPhysicsJointFixed(bodyA: SKNode,bodyB : SKNode, anchor:CGPoint) -> SKPhysicsJointFixed{
        var localPt = CGPoint(x: bodyA.position.x + anchor.x * originSize!.width, y: bodyA.position.y + anchor.y * originSize!.height)
        
        var pos =  GameScene.current?.convertPoint(anchor, fromNode: bodyA.parent!)
        print(pos)
        var joint = SKPhysicsJointFixed.jointWithBodyA(bodyA.physicsBody!, bodyB: bodyB.physicsBody!, anchor: pos!)
        return joint
    }
}