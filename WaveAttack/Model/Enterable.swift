//
//  Enterable.swift
//  WaveAttack
//
//  Created by yat on 16/11/2015.
//
//

import Foundation
import SpriteKit

protocol Enterable {
    func enter( obj :GameObject)
    func getPosition() -> CGPoint
    
   
}