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
    
    override var path: CGPath? { get{ return _path}}
    var xDivMax: CGFloat  {get { fatalError(); return 1}} // for edge path
    var yDivMax: CGFloat {get {fatalError() ; return 1}}
    var _path : CGPath? = nil
    var moveRound : Int = 3
    var currentRound : Int = 0
    var hpBar : HpBar? = nil
    var hpBarRect :CGRect? = nil
    var roundLabel : ActRoundLabel? = nil
    var roundRect : CGRect? = nil
    var dead : Bool = false
    var originSize :CGSize? = nil
    var originPoint :CGPoint? = nil
//----crack UI---
    var crackUI :SKSpriteNode? = nil
    var cropCrackUI :SKCropNode? = nil
    var completeCrack :Bool = false
    var restitution : CGFloat  {get{return 0.1}}
//-----new
    var textures:[SKTexture]? {get{return nil}}
    var sprites = [GameSKSpriteNode]()
    var attachedIndex = 0
    var sprite = SKSpriteNode()
    var joints = [SKPhysicsJoint]()
    var stopFunctioning : CGFloat { return 0.4}
    var breakThreshold : [CGFloat]? {get{return nil}}
    var breakIndex  : Int? = nil
    var density : CGFloat? { get{return nil}}
    var mass : CGFloat  = 0
    var unionNode : GameSKSpriteNode = GameSKSpriteNode()
    var unionJoint : SKPhysicsJoint? = nil
    var isFront = [SKNode:Bool]()
    var allPhysicsBody = [SKPhysicsBody]()
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
            sprite.physicsBody = createNoCollisionPhysicsBody(sprite.texture!, size: size)
            //sprite.physicsBody = createNoCollisionPhysicsBody(texture, size: size)
            allPhysicsBody.append(sprite.physicsBody!)
            isFront[sprite] = false
            attachedIndex++
            self.sprite.addChild( sprite)
            self.sprites.append(sprite)
            
        }
        var phys =  createPhysicsBody(bodies: allPhysicsBody)
        unionNode.physicsBody = phys
        unionNode.gameObject = self
        isFront[unionNode] = false
        sprite.addChild(unionNode)
    
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
    func createPhysicsBody(texture: SKTexture ,size: CGSize) -> SKPhysicsBody {
        var phys = SKPhysicsBody (texture: texture, size: size)
        phys.categoryBitMask = CollisionLayer.Objects.rawValue
        phys.affectedByGravity = true
        phys.collisionBitMask = CollisionLayer.Objects.rawValue | CollisionLayer.Ground.rawValue | CollisionLayer.GameBoundary.rawValue
        phys.contactTestBitMask = CollisionLayer.Objects.rawValue | CollisionLayer.Ground.rawValue 
        phys.dynamic = true
        phys.usesPreciseCollisionDetection = true
        phys.density = self.density!
        phys.restitution = self.restitution
        return phys
    }
    func createPhysicsBody(size: CGSize) -> SKPhysicsBody {
        var phys =  SKPhysicsBody(rectangleOfSize: size)
        phys.categoryBitMask = CollisionLayer.Objects.rawValue
        phys.affectedByGravity = true
        phys.collisionBitMask = CollisionLayer.Objects.rawValue | CollisionLayer.Ground.rawValue | CollisionLayer.GameBoundary.rawValue
        phys.contactTestBitMask = CollisionLayer.Objects.rawValue | CollisionLayer.Ground.rawValue
        phys.dynamic = true
        phys.usesPreciseCollisionDetection = true
        phys.density = self.density!
        phys.restitution = self.restitution
        return phys
    }
    func createPhysicsBody(bodies physicsBodies: [SKPhysicsBody])  -> SKPhysicsBody {
        var phys = SKPhysicsBody (bodies: physicsBodies)
        phys.categoryBitMask = CollisionLayer.Objects.rawValue
        phys.affectedByGravity = true
        phys.collisionBitMask = CollisionLayer.Objects.rawValue | CollisionLayer.Ground.rawValue | CollisionLayer.GameBoundary.rawValue
        phys.contactTestBitMask = CollisionLayer.Objects.rawValue | CollisionLayer.Ground.rawValue
        phys.dynamic = true
        phys.usesPreciseCollisionDetection = true
        phys.density = self.density!
        phys.restitution = self.restitution
        return phys
    }
    func createNoCollisionPhysicsBody(texture: SKTexture ,size: CGSize) -> SKPhysicsBody {
        var phys = SKPhysicsBody (texture: texture, size: size)
        phys.categoryBitMask = 0
        phys.affectedByGravity = true
        phys.collisionBitMask = 0
        phys.contactTestBitMask = 0
        phys.dynamic = true
        phys.usesPreciseCollisionDetection = true
        phys.density = self.density!
        phys.restitution = self.restitution
        return phys
    }
    func createNoCollisionPhysicsBody(size: CGSize) -> SKPhysicsBody {
        var phys =  SKPhysicsBody(rectangleOfSize: size)
        phys.categoryBitMask = 0
        phys.affectedByGravity = true
        phys.collisionBitMask = 0
        phys.contactTestBitMask = 0
        phys.dynamic = true
        phys.usesPreciseCollisionDetection = true
        phys.density = self.density!
        phys.restitution = self.restitution
        return phys
    }
    override func afterAddToScene() {
        
        var keyPart = sprites[0]
       
        for part in  sprites{
            if part === keyPart{
                continue
            }
            joints.append(createPhysicsJointFixed(keyPart, bodyB: part, anchor: CGPoint()))
        }
        unionJoint = (createPhysicsJointFixed(keyPart, bodyB: unionNode, anchor: CGPoint()))
        GameScene.current!.physicsWorld.addJoint(unionJoint!)
        fixedOnGround()
        
        for joint in joints{
            GameScene.current!.physicsWorld.addJoint(joint)
        }

        
    }
    
    func fixedOnGround(){
        
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
        
        guard breakThreshold != nil else{return }
        if breakIndex == nil{
            breakIndex = breakThreshold!.count - 1
        }
        guard breakIndex! >= 0 else { return }
        if hp/self.originHp < breakThreshold![breakIndex!]{
            if unionNode.physicsBody!.resting == false{
                return
            }
            breakIndex!--
            var  node = sprites[--attachedIndex]
            mass -= node.physicsBody!.mass
           node.gameObject = nil
            GameScene.current!.physicsWorld.removeJoint(joints.removeLast())
            node.physicsBody! = createNoCollisionPhysicsBody(node.texture!, size: originSize!)
            changeToFront(node.physicsBody!)
            allPhysicsBody.removeLast()
           updateUnionNode()
            
        }
        
        
        
        
    }
    
    func updateUnionNode(){
        unionNode.physicsBody = createPhysicsBody(bodies: allPhysicsBody)
        if isFront[unionNode]! == true {
            changeToFront(unionNode.physicsBody!)
        }
        GameScene.current!.physicsWorld.removeJoint(unionJoint!)
        unionJoint = createPhysicsJointFixed(sprites[0], bodyB:unionNode , anchor: CGPoint())
        GameScene.current!.physicsWorld.addJoint(unionJoint!)
    }
    
    func changeToFront(phys :SKPhysicsBody){
        isFront[phys.node!] = true
        phys.categoryBitMask = CollisionLayer.FrontObjects.rawValue
        phys.collisionBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue | CollisionLayer.GameBoundary.rawValue
        phys.contactTestBitMask = CollisionLayer.FrontObjects.rawValue | CollisionLayer.FrontGround.rawValue
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
    
    
    
    
    
    
   
    
   
    func calculateDamage(packet : EnergyPacket){
        var damage: CGFloat = packet.energy * absorptionRate
        packet.energy = packet.energy - damage
        damage = damage - damageReduction
        if (damage < 0){
            damage = 0
        }
        _hp = hp - damage
        totDmg = totDmg + damage
        if (hp < 0 && dead == false){
//            print("destory")
            die()
        }
       // SKAction.ap
      //  packet.direction.normalize()
       // print(packet.direction)
        var dir = 0.07 * damage * packet.forceDir * CGVector(dx: packet.direction.dy, dy: -packet.direction.dx)
        
    //    print(dir)
        packet.forceDir = -packet.forceDir
   //     print(damage)
        
        getSprite()!.physicsBody!.applyImpulse(dir, atPoint: packet.getSprite()!.position)
        
       triggerEvent(GameEvent.HpChanged.rawValue)
        
        
        return
    }

    
    func impulseDamage(impulse : CGFloat, contactPt: CGPoint){
        let threshold:CGFloat = 10 * mass
        
        guard impulse > threshold  else{
            return
        }
        
        var damage = (impulse - threshold)  * (1 - restitution)
        
        
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
        self.gameScene = GameScene.current!
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
        CGPathMoveToPoint(path, nil, CGFloat(tempx) - offsetX , CGFloat(tempy) - offsetY)
        
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
        for obj in self.packets{
            if (obj.deleted == false){
                obj.deleteSelf()
            }
        }
        self.packets.removeAll()
        self.getSprite()!.removeAllChildren()
        self.gameScene!.gameLayer!.removeGameObject(self)
        if hpBar != nil{
            hpBar!.removeFromParent()
            hpBar = nil
        }
        if roundLabel != nil{
            roundLabel!.removeFromParent()
            roundLabel = nil
        }
        
        
        
        
    }
//-------misc-------
    func createHpBar(){
        return
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
        triggerEvent(GameEvent.Dead.rawValue)
        
    }
    
    override func syncPos() {
        super.syncPos()
        return
        var dest = self
         var selfPos = getSprite()!.position
        //print(selfPos)
        if self.target{
           
          //  print(self.getSprite()!.frame)
            //print(self.getSprite()!.calculateAccumulatedFrame())
             dest.hpBar!.position = CGPoint(x: selfPos.x, y: selfPos.y - self.getSprite()!.frame.height/2 - 10)
            //print(dest.hpBar!.position)
           //dest.hpBar!.position = dest.hpBar!.position + diff
          //  print(dest.hpBar!.position)

            //print(barpos)
            //print(dest.hpBar!.position)
        }
        if (self is EnemyActable){
            
            var diff :CGVector = selfPos - self.originPoint!
            dest.roundLabel!.position = dest.roundLabel!.position + diff
        }
        self.originPoint = selfPos
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