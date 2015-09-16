//
//  Cloneable.swift
//  WaveAttack
//
//  Created by yat on 15/9/2015.
//
//

import Foundation
import SpriteKit
protocol Cloneable{
    func clone() -> AnyObject?
    func newInstance() -> AnyObject?
}

