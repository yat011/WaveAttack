//
//  WaveAttack
//
//  Created by yat on 6/10/2015.
//
//

import Foundation
import SpriteKit


class ConfirmWindow : SKShapeNode, Clickable{
    
    weak var gameScene :GameScene? = nil
    var titleLabel : SKLabelNode? = nil
   // var yesFunc : (()->())? = nil
    var yesButton : ButtonUI? = nil
    var noButton : ButtonUI? = nil
  
    static func createConfirmUI(rect: CGRect, yesFunc:(()->()), noFunc:(()->()),  gameScene: GameScene ) -> ConfirmWindow{
        var res = ConfirmWindow(rectOfSize: rect.size, cornerRadius: 2)
        res.position = rect.origin
        print(res.position)
        res.fillColor = SKColor.blackColor()
        res.strokeColor = SKColor.brownColor()
        res.alpha = 1
        var label =  SKLabelNode(text: "Back to Main Menu?")
        label.fontName = "Helvetica"
        label.fontSize = 20
       // label.position = CGPoint(x: rect.origin.x + rect.size.width / 2, y: rect.origin.y + rect.size.height / 1.1)
        res.titleLabel = label
        label.position = CGPoint(x: 0, y: 50)
        res.addChild(label)
       // res.yesFunc = yesFunc
        
        
        res.yesButton = ButtonUI.createButton(CGRect(x: -35, y: -20, width: 30, height: 20), text: "Yes", onClick: yesFunc, gameScene: gameScene)
        
        res.noButton = ButtonUI.createButton(CGRect(x: +35, y: -20, width: 30, height: 20), text: "No", onClick: noFunc, gameScene: gameScene)
        
        res.addChild(res.yesButton!)
        res.addChild(res.noButton!)
        gameScene.addClickable(GameStage.Pause, res.yesButton!)
        gameScene.addClickable(GameStage.Pause, res.noButton!)
        
        /*
        res.gradeLabel = SKLabelNode(fontNamed: "Helvetica")
        res.gradeLabel!.text = String (format: GRADE_STR, "S" )
        res.gradeLabel!.fontSize = 18
        res.gradeLabel!.horizontalAlignmentMode = .Left
        res.gradeLabel!.position = CGPoint(x: rect.origin.x + 10, y: rect.origin.y + rect.size.height / 2)
        
        res.numRoundsLabel = SKLabelNode(fontNamed: "Helvetica")
        res.numRoundsLabel!.text = String (format: NUM_ROUNDS_STR, 0 )
        res.numRoundsLabel!.fontSize = 18
        res.numRoundsLabel!.horizontalAlignmentMode = .Left
        res.numRoundsLabel!.position = CGPoint(x: rect.origin.x + 10, y: rect.origin.y + rect.size.height / 2 - 50)
*/
        res.gameScene = gameScene
        //res.addChild(res.gradeLabel!)
        //res.addChild(res.numRoundsLabel!)
        res.zPosition = 1000000
        
        return res
        
    }
    
    
    /*
    func showResult (finish : (()->())){
        var current = 0
        var target = gameScene!.numRounds
        var grades = gameScene!.mission!.gradeDiv
        var grade  = 0
        var f :(()->())!
        f = {() -> () in
            if current == target{
                finish()
                self.numRoundsLabel!.runAction(SKAction.scaleBy(1.2, duration: 0.5))
                self.gradeLabel!.runAction(SKAction.scaleBy(1.2, duration: 0.5))
                return
            }else{
                current += 1
                self.numRoundsLabel!.text = String (format: ResultUI.NUM_ROUNDS_STR, current )
                if grade < grades.count && current >= grades[grade] {
                    grade += 1
                    self.gradeLabel!.text = String(format: ResultUI.GRADE_STR,  self.gameScene!.grading[grade])
                    
                }
                self.runAction(SKAction.waitForDuration(0.1), completion : f )
            }
            
        }
        
        runAction(SKAction.waitForDuration(0.1), completion: f)
        
        // finish()
    }
*/
    
    func checkClick(touchPoint: CGPoint) -> Clickable? {
        if (CGRectContainsPoint(yesButton!.getRect(), touchPoint)){
            return yesButton!
        }else if (CGRectContainsPoint(noButton!.getRect(), touchPoint)){
            return noButton!
        }
        
        return nil
    }
    
    func click() {
        
    }
    
    func getRect() -> CGRect {
        var globalPos = gameScene!.convertPoint(self.frame.origin, fromNode: self.parent!)
        // print (globalPos)
        return CGRect (origin: globalPos, size: self.frame.size)
    }
    
    
    
    
}