//
//  EnemyAction.swift
//  WaveAttack
//
//  Created by yat on 2/10/2015.
//
//

import Foundation

protocol EnemyAction {
   
    func runAction(finish : (() -> ()))
    func initialize(enemy :DestructibleObject)
}