//
//  ResultUI.swift
//  WaveAttack
//
//  Created by yat on 6/10/2015.
//
//

import Foundation
import SpriteKit


class ResultUI : SKShapeNode{
    
    var gradeLabel: SKLabelNode? = nil
    var numRoundsLabel : SKLabelNode? = nil
    var scoreLabel : SKLabelNode? = nil
    var timeLabel: SKLabelNode? = nil
    var title: SKLabelNode? = nil
    weak var gameScene :GameScene? = nil
    static let GRADE_STR = "Grade %@"
    static let NUM_ROUNDS_STR = "Rounds Used %d"
    static let TIME_STR = "Time: %.1f"
    static let SCORE_TIME_STR = "Score: %.1f * %.1f"
    static let SCORE_STR = "Score: %.1f"
    static func createResultUI(rect: CGRect, gameScene: GameScene ) -> ResultUI{
        var res = ResultUI (rectOfSize: rect.size, cornerRadius: 2)
        res.position = rect.origin
        res.fillColor = SKColor.blackColor()
        res.strokeColor = SKColor.brownColor()
        res.alpha = 0.8
        var label =  SKLabelNode(text: "Mission Complete")
        label.fontName = "Helvetica"
        label.position = CGPoint(x: 0, y:  200)
        res.title = label
        res.addChild(label)
        
        
        res.gradeLabel = SKLabelNode(fontNamed: "Helvetica")
        res.gradeLabel!.text = String (format: GRADE_STR, "S" )
        res.gradeLabel!.fontSize = 18
        res.gradeLabel!.horizontalAlignmentMode = .Left
        res.gradeLabel!.position = CGPoint(x:  -120, y: 0)

        res.numRoundsLabel = SKLabelNode(fontNamed: "Helvetica")
        res.numRoundsLabel!.text = String (format: NUM_ROUNDS_STR, 0 )
        res.numRoundsLabel!.fontSize = 18
        res.numRoundsLabel!.horizontalAlignmentMode = .Left
        res.numRoundsLabel!.position = CGPoint(x: -120, y: -50)
        res.gameScene = gameScene
        
        res.scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        res.scoreLabel!.text = ""
        res.scoreLabel!.fontSize = 18
        res.scoreLabel!.horizontalAlignmentMode = .Left
        res.scoreLabel!.position = CGPoint(x: -120, y: -50)
        
        res.timeLabel = SKLabelNode(fontNamed: "Helvetica")
        res.timeLabel!.text = ""
        res.timeLabel!.fontSize = 18
        res.timeLabel!.horizontalAlignmentMode = .Left
        res.timeLabel!.position = CGPoint(x: -120, y: 0)
        
        var menuButton = ButtonUI.createButton(CGRect(x:0, y: -150, width:150, height: 30), text: "Back to Main Menu", onClick: {
            () -> () in
                gameScene.BackToMenu()
            }, gameScene: gameScene)
         //GameViewController.current!.dismissViewControllerAnimated(true, completion: nil)
        
        gameScene.addClickable(GameStage.Complete, menuButton)
        res.addChild(menuButton)
        
       // res.addChild(res.gradeLabel!)
       // res.addChild(res.numRoundsLabel!)
        res.addChild(res.scoreLabel!)
        res.addChild(res.timeLabel!)
        res.zPosition = 1000000
        
        return res
        
    }
 
    
    
    func showResult (finish : (()->())){
      
        var current:CGFloat = 0
        
        var time = gameScene!.gameLayer!.totalTimer.currentTime
        var score =  gameScene!.totalScore
        /*
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
*/
        timeLabel!.text  = String(format: ResultUI.TIME_STR,time)
        self.timeLabel!.runAction(SKAction.scaleBy(1.2, duration: 0.5))
        var bonus =  gameScene!.bonus
        scoreLabel!.text = String(format:ResultUI.SCORE_TIME_STR , score , bonus )
        AnimateHelper.animateFlashEffect(scoreLabel!, duration: 2, completion: {
            () -> () in
           self.scoreLabel!.text = String(format: ResultUI.SCORE_STR, Float(score) * bonus)
            self.scoreLabel!.runAction(SKAction.scaleBy(1.2, duration: 0.5))
        })
        
        
        
        
       // finish()
    }
    
    func showLose(finish : (()->())){
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
                self.gradeLabel!.text = String(format: ResultUI.GRADE_STR,  "F")
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
        
    }
    
    
    
}