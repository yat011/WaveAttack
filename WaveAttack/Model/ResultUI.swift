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
    weak var gameScene :GameScene? = nil
    static let GRADE_STR = "Grade %@"
    static let NUM_ROUNDS_STR = "Rounds Used %d"
    static func createResultUI(rect: CGRect, gameScene: GameScene ) -> ResultUI{
        var res = ResultUI (rect: rect, cornerRadius: 2)
        res.fillColor = SKColor.blackColor()
        res.strokeColor = SKColor.brownColor()
        res.alpha = 0.7
        var label =  SKLabelNode(text: "Mission Complete")
        label.fontName = "Helvetica"
        label.position = CGPoint(x: rect.origin.x + rect.size.width / 2, y: rect.origin.y + rect.size.height / 1.3)
        res.addChild(label)
        
        
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
        res.gameScene = gameScene
        res.addChild(res.gradeLabel!)
        res.addChild(res.numRoundsLabel!)
        res.zPosition = 1000000
        
        return res
        
    }
 
    
    
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
    
    
    
    
}