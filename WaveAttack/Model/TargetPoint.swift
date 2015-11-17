//
//  EndPoint.swift
//  WaveAttack
//
//  Created by yat on 16/11/2015.
//
//

import Foundation
import SpriteKit

class TargetPoint : Enterable{
    var pos =  CGPoint()
    func enter( obj :GameObject){
        
    }
    func getPosition() -> CGPoint{
       return pos
    }
}