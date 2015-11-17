//
//  UIScene.swift
//  WaveAttack
//
//  Created by James on 21/9/15.
//
//

import Foundation
import SpriteKit

class UINode: SKNode,Draggable{
    var resultantWaveShape: SKNode? = nil
    var timerUI : TimerUI? = nil
    var waveButtons :[UIWaveButton] = []
    weak var gameScene: GameScene? = nil
    var cropNode : SKCropNode? = nil
    var stateLabel :SKLabelNode = SKLabelNode(fontNamed: "Helvetica")
    var waveButtonsGroup : SKNode? = nil
    var waveUIGroup :SKNode? = nil
    init(position : CGPoint, parent:GameScene){
        super.init()
        self.position = position
        self.name = "UINode"
        
        var character0:Character
        var UIWaveButton0:UIWaveButton
        let UIWaveButtonGroup=SKNode()
        UIWaveButtonGroup.name="UIWaveButtonGroup"
        var temppos :[CGFloat] = [-415, -547,-562,-565,-569]
       
        var characters = PlayerInfo.team.characters?.allObjects
        print(characters!.count)
        var chs : [Character?] = []
        
        for var i = 4; i >= 0 ; i-- {
            var current = PlayerInfo.getCharacterAt(i)
            if (current == nil){
                chs.append(nil)
                continue
            }
            chs.append( CharacterManager.getCharacterByID(current!.characterId!.integerValue)!)
        }
         parent.character = chs
        for i in 0...4
        {
            //get team list
            if (chs[i] == nil){
                continue
            }
            character0=chs[i]!
            UIWaveButton0 = UIWaveButton(size: CGSize(width: 300, height: 66), position: CGPoint(x: 0, y: 66 * Double(i) + 33), wave:character0.getWave())
            UIWaveButton0.zPosition=12
            UIWaveButton0.name="UIWaveButton"
            //UIWaveButton0.waveShapeNode!.position = CGPoint(x: temppos[i],y:0)
            waveButtons.append(UIWaveButton0)
            UIWaveButtonGroup.addChild(UIWaveButton0)
            chs[i]!.waveUI = UIWaveButton0
        }
        var tempCrop = SKCropNode()
        var maskNode = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 300,height: 333.5))
        maskNode.position = CGPoint(x: 0, y: 166.75)
            
        tempCrop.maskNode = maskNode
        //self.addChild(UIWaveButtonGroup)
        tempCrop.addChild(UIWaveButtonGroup)
        waveUIGroup = UIWaveButtonGroup
        tempCrop.zPosition = 12
        self.addChild(tempCrop)
        
        
        
        var UICharacterButton0:UICharacterButton
        let UICharacterButtonGroup=SKNode()
        UICharacterButtonGroup.name="UICharacterButtonGroup"
      
        for i in 0...4
        {
            if (chs[i] == nil){
                return
            }
            UICharacterButton0 = UICharacterButton(size: CGSize(width: 35, height: 35), position: CGPoint(x:-153-35/2 , y: 66 * Double(i) + 33), character: chs[i])
            UICharacterButton0.zPosition=999
            UICharacterButton0.name="UICharacterButton0"
            UICharacterButtonGroup.addChild(UICharacterButton0)
            parent.addClickable(GameStage.Superposition, UICharacterButton0)
            
        }
        self.addChild(UICharacterButtonGroup)
        
        /*
        var w=Wave.superposition((self.children[0] as! UIWaveButton).wave, d1: 10,
            w2: Wave.superposition((self.children[1] as! UIWaveButton).wave, d1: 175,
                w2: Wave.superposition((self.children[2] as! UIWaveButton).wave, d1: 222,
                    w2: Wave.superposition((self.children[3] as! UIWaveButton).wave, d1: 210, w2: (self.children[4] as! UIWaveButton).wave, d2: 111), d2: 70), d2: 99), d2:123)
        */
        
        
   
        let UIBackground = SKSpriteNode(imageNamed: "UIBackground")
        //SKSpriteNode(texture: nil, color: UIColor.darkGrayColor(), size: CGSize(width: parent.size.width, height: parent.size.height/2))
        UIBackground.size = CGSize(width: parent.size.width, height: parent.size.height/2)
        UIBackground.position=CGPoint(x: 0, y: parent.size.height/4)
        UIBackground.zPosition = -1
        self.addChild(UIBackground)
        //hollow texture for cropping
        
        let UIForeground = SKNode()
        UIForeground.name="UIForeground"
        UIForeground.zPosition=10
    //    self.addChild(UIForeground)
        
        var c = MathHelper.boundsToCGRect(-parent.size.width/2, x2: -150, y1: 0, y2: parent.size.height/2)
        var UIForeground0 = SKSpriteNode(imageNamed: "UIBackground")
        //SKSpriteNode(texture: nil, color: UIColor.blackColor(), size: CGSize(width: c.width, height: c.height))
        UIForeground0.size = CGSize(width: c.width, height: c.height)
        UIForeground0.position=CGPoint(x: c.midX,y: c.midY)
        UIForeground.addChild(UIForeground0)
        c = MathHelper.boundsToCGRect(parent.size.width/2, x2: 150, y1: 0, y2: parent.size.height/2)
        UIForeground0 = SKSpriteNode(texture: nil, color: UIColor.blackColor(), size: CGSize(width: c.width, height: c.height))
        UIForeground0.position=CGPoint(x: c.midX,y: c.midY)
       // UIForeground.addChild(UIForeground0)
        
        
        let background = SKSpriteNode(texture: nil, color: UIColor(red: 0x42/255, green: 0x42/255, blue: 0x3f/255, alpha: 1), size: CGSize(width: 300, height: 335.5))
        background.position = CGPoint(x: 0, y: 166.5)
        self.addChild(background)
        background .zPosition = -1
        self.timerUI = TimerUI.createInstance()
        parent.addClickable(GameStage.Supering,self.timerUI!)
        self.addChild(self.timerUI!)
        
        
        gameScene = parent
        
        
        cropNode = SKCropNode()
        var mask = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 300, height: 333.5))
        mask.position = CGPoint(x:0, y:166.5)
        cropNode!.maskNode = mask
        //cropNode!.position = CGPoint(x:-70, y:166.5)
        //cropNode!.zPosition = 12
        UIBackground.zPosition = -1
        background.zPosition = 0
        
        self.addChild(cropNode!)
        
        
        
        stateLabel.zPosition = 11
        stateLabel.text = "Attacking"
        stateLabel.position = CGPoint(x: 0, y: 166.5)
        stateLabel.hidden = true
        self.addChild(stateLabel)
        
       // self.zPosition = 1000000
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawSuperposition()->Wave{
        let w0=waveButtons[0]
        let w1=waveButtons[1]
        let w2=waveButtons[2]
        let w3=waveButtons[3]
        let w4=waveButtons[4]
        
        //print(w0.waveShapeNode!.position)
        //print(w1.waveShapeNode!.position)
        //print(w2.waveShapeNode!.position)
        //print(w3.waveShapeNode!.position)
        //print(w4.waveShapeNode!.position)
        
        var d0 = (w0.waveShapeNode?.position.x)!
        d0 = -d0+750
        var d1 = (w1.waveShapeNode?.position.x)!
        d1 = -d1+750
        var d2 = (w2.waveShapeNode?.position.x)!
        d2 = -d2+750
        var d3 = (w3.waveShapeNode?.position.x)!
        d3 = -d3+750
        var d4 = (w4.waveShapeNode?.position.x)!
        d4 = -d4+750
        //print(w0.waveShapeNode?.position.x)
        
        var w=Wave.superposition(w0.wave,d1: Int(d0),
            w2: Wave.superposition(w1.wave,d1: Int(d1),
                w2: Wave.superposition(w2.wave,d1: Int(d2),
                    w2: Wave.superposition(w3.wave,d1: Int(d3),
                        w2: w4.wave, d2: Int(d4)), d2:0), d2:0), d2:0)
        //wave displacement check
        //w=Wave.superposition(w0.wave,d1: Int(d0),w2: w0.wave,d2: Int(d0))
        w.normalize()
        let n=w.getShape()
        n.position=CGPoint(x:-150, y:166.5)
        if (self.resultantWaveShape != nil){
            self.resultantWaveShape!.removeFromParent()
        }else{
            let path:CGMutablePathRef=CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 0, 0)
            CGPathAddLineToPoint(path, nil, 300, 0)
            var dottedLine = SKShapeNode(path: CGPathCreateCopyByDashingPath(path, nil, 0, [5,5], 2)!)
            dottedLine.alpha = 0.5
            dottedLine.position = CGPoint(x: 0, y: 0)
            n.addChild(dottedLine)
        
        }
        self.resultantWaveShape = n
        self.cropNode!.addChild(self.resultantWaveShape!)
        return w
    }
    var upperResultant : SKNode? = nil
    var lowerResultant : SKNode? = nil
    
    func animateSuperposition(completion:(()->())){
        var i = 0
        
        animateFirstSuperposition(4, to: 3,completion : {
            (resultNode: SKNode)->()in
            self.upperResultant = resultNode
            if (self.upperResultant != nil && self.lowerResultant != nil){
                self.animateFinalSuperposition(completion)
            }
        })
        animateFirstSuperposition(0, to: 1, completion : {
            (resultNode: SKNode)->()in
            self.lowerResultant = resultNode
            if (self.upperResultant != nil && self.lowerResultant != nil){
                self.animateFinalSuperposition(completion)
            }
        })
        /*
        for btn in waveButtons{
            var action = [SKAction.moveToY(66 * CGFloat(2) + 33, duration: 0.5),SKAction.scaleYTo(4, duration: 0.5),SKAction.waitForDuration(1),SKAction.fadeOutWithDuration(0.5)]
            if i == 0 {
                btn.runAction(SKAction.sequence(action), completion: completion)
            }else{
                btn.runAction(SKAction.sequence(action))
            }
            i++
        }
*/
    }
    func animateFirstSuperposition(from :Int , to:Int, completion : ((SKNode)->())) {
        var destY = (self.waveButtons[from].position.y + self.waveButtons[to].position.y)/2
        var actions = [ SKAction.moveToY(destY, duration: 0.5)]
        waveButtons[to].boundary?.hidden = true
        waveButtons[from].boundary?.hidden = true
        waveButtons[to].runAction(SKAction.moveToY(destY, duration: 0.5))
        waveButtons[from].runAction( SKAction.moveToY(destY, duration: 0.5),  completion:{
            ()->() in
            var x4 = -self.waveButtons[from].waveShapeNode!.position.x + 750
            var x3 = -self.waveButtons[to].waveShapeNode!.position.x + 750
            var result: SKNode? = Wave.superposition(self.waveButtons[from].wave,d1: Int(x4), w2: self.waveButtons[to].wave, d2: Int(x3)).getShape()
            result!.position = CGPoint(x: -150, y: destY)
            result!.alpha = 0
            result!.zPosition = 200000000
            self.waveUIGroup?.addChild(result!)
            result!.runAction(SKAction.fadeInWithDuration(0.4))
            self.waveButtons[from].runAction(SKAction.fadeOutWithDuration(0.4))
            self.waveButtons[to].runAction(SKAction.fadeOutWithDuration(0.4))
          //  self.waveButtons[from].hidden=true
           // self.waveButtons[to].hidden=true
            completion(result!)
        })
    }
    
    
    func animateFinalSuperposition (completion: (()->())){
        var action = [SKAction.moveToY(66 * CGFloat(2) + 33, duration: 1),SKAction.waitForDuration(1),SKAction.fadeOutWithDuration(0.5)]
        self.waveButtons[2].boundary?.hidden = true
        self.waveButtons[2].runAction(SKAction.sequence([SKAction.waitForDuration(2),SKAction.fadeOutWithDuration(0.5)]))
        self.upperResultant!.runAction(SKAction.sequence(action), completion: completion)
        self.lowerResultant!.runAction(SKAction.sequence(action))
        
        
    }
    func animateGeneration(wave : Wave, completion:(()->())){
       var amp = wave.getAmplitudes()
        var generated: [Bool] = [Bool](count:amp.count, repeatedValue: false)
        let speed: CGFloat = 15
        var callBack :(()->())? = nil
        callBack = {
            () -> () in
            var done = true
            for var i = 0 ; i < amp.count ; i++ {
 
                if (generated[i] == false && amp[i] + self.resultantWaveShape!.position.y > 333.5) {
                    print(amp[i])
                   // self.gameScene!.generatePacket(amp, i)
                    generated[i] = true
                    done = false
                }else if generated[i] == false {
                    done = false
                }
            }
            if done{
                completion()
            }else{
                self.resultantWaveShape!.runAction(SKAction.moveByX(0, y: speed, duration: 0.1), completion: callBack!)
            }
        }
        
        resultantWaveShape?.runAction(SKAction.moveByX(0, y: speed, duration: 0.1), completion: callBack!)
        
        
    }
    
    
    func showWaveButtons(){
        var i:CGFloat = 0
        if self.resultantWaveShape != nil{
            self.resultantWaveShape!.removeFromParent()
            self.resultantWaveShape = nil
        }
        for btn in waveButtons{
            var actions = [SKAction.moveToY(66 * CGFloat(i) + 33, duration: 0),SKAction.scaleYTo(1, duration: 0), SKAction.fadeInWithDuration(0.5)]
            btn.runAction(SKAction.sequence(actions))
            btn.boundary?.hidden = false
            btn.scroll(CGFloat(rand()) % 300, dy: 0)
            i++
        }
    }
    
    func checkClick(touchPoint : CGPoint)-> Clickable?{
        let rect  = getRect()
        if (CGRectContainsPoint(rect, touchPoint)){
            return self
        }
        return nil
    }
    func getRect () -> CGRect{
        return self.calculateAccumulatedFrame()
    }
    func click(){
        
    }
    func scroll(dx:CGFloat, dy:CGFloat){
        let newY = self.position.y + dy
        self.runAction(SKAction.moveToY(newY, duration: 0))
    }
    func scroll(x:CGFloat, y:CGFloat){
        self.runAction(SKAction.moveToY(y, duration: 0))
    }
    
    
    static func createDottedLine(width : CGFloat)-> SKNode{
        let path:CGMutablePathRef=CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddLineToPoint(path, nil, width, 0)
        var dottedLine = SKShapeNode(path: CGPathCreateCopyByDashingPath(path, nil, 0, [5,5], 2)!)
        dottedLine.alpha = 0.5
        dottedLine.position = CGPoint(x: 0, y: 0)
        return dottedLine
    }
    
}