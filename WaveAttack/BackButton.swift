//
//  BackButton.swift
//  WaveAttack
//
//  Created by James on 25/10/15.
//
//

import Foundation
import SpriteKit

class BackButton:SKSpriteNode,Interactable{
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        let backLabel=SKLabelNode(text: "Back")
        backLabel.fontSize = 16
        backLabel.fontColor = SKColor.whiteColor()
        backLabel.horizontalAlignmentMode = .Center
        backLabel.verticalAlignmentMode = .Center
        backLabel.fontName = "Helvetica"
        addChild(backLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getClass()->String{
        return "BackButton"
    }

    func onClick(){
        (self.scene! as! TransitableScene).viewController!.sceneTransitionBackward()
    }
}